import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Estimate } from '../entities/estimate.entity';
import { EstimateItem } from '../entities/estimate-item.entity';
import { CreateEstimateDto } from '../dto/create-estimate.dto';
import { MicroserviceClientService } from './microservice-client.service';

@Injectable()
export class EstimateService {
  constructor(
    @InjectRepository(Estimate)
    private estimateRepository: Repository<Estimate>,
    @InjectRepository(EstimateItem)
    private estimateItemRepository: Repository<EstimateItem>,
    private microserviceClient: MicroserviceClientService,
  ) {}

  async create(createEstimateDto: CreateEstimateDto): Promise<Estimate> {
    const { items, ...estimateData } = createEstimateDto;
    
    // Generate estimate number
    const estimateNumber = await this.generateEstimateNumber(createEstimateDto.locationId);
    
    // Calculate totals
    const totalAmount = items.reduce((sum, item) => sum + (item.quantity * item.unitPrice), 0);
    const discountAmount = createEstimateDto.discountAmount || 0;
    const netAmount = totalAmount - discountAmount;

    // Create estimate
    const estimate = this.estimateRepository.create({
      ...estimateData,
      estimateNumber,
      totalAmount,
      discountAmount,
      netAmount,
    });

    const savedEstimate = await this.estimateRepository.save(estimate);

    // Create estimate items
    const estimateItems = items.map(item => 
      this.estimateItemRepository.create({
        ...item,
        estimateId: savedEstimate.id,
        totalPrice: item.quantity * item.unitPrice,
      })
    );

    await this.estimateItemRepository.save(estimateItems);

    return this.findOne(savedEstimate.id);
  }

  async findAll(locationId: number): Promise<Estimate[]> {
    return this.estimateRepository.find({
      where: { locationId },
      relations: ['items', 'location'],
      order: { createdAt: 'DESC' },
    });
  }

  async findOne(id: number): Promise<Estimate> {
    const estimate = await this.estimateRepository.findOne({
      where: { id },
      relations: ['items', 'location'],
    });

    if (!estimate) {
      throw new NotFoundException(`Estimate with ID ${id} not found`);
    }

    return estimate;
  }

  async updateStatus(id: number, status: string): Promise<Estimate> {
    await this.estimateRepository.update(id, { status });
    return this.findOne(id);
  }

  async convertToBill(id: number, userId: number): Promise<any> {
    const estimate = await this.findOne(id);
    
    // Prepare bill data
    const billData = {
      locationId: estimate.locationId,
      patientId: estimate.patientId,
      totalAmount: estimate.totalAmount,
      discountAmount: estimate.discountAmount,
      netAmount: estimate.netAmount,
      createdBy: userId,
      items: estimate.items.map(item => ({
        itemName: item.itemName,
        itemCode: item.itemCode,
        quantity: item.quantity,
        unitPrice: item.unitPrice,
        totalPrice: item.totalPrice,
        category: item.category,
      })),
    };

    // Create bill via billing service
    const bill = await this.microserviceClient.createBill(billData);
    
    // Update estimate status
    await this.updateStatus(id, 'accepted');

    return bill;
  }

  private async generateEstimateNumber(locationId: number): Promise<string> {
    const count = await this.estimateRepository.count({ where: { locationId } });
    return `EST${locationId.toString().padStart(3, '0')}${(count + 1).toString().padStart(6, '0')}`;
  }
}