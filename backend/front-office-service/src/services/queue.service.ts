import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { PatientQueue } from '../entities/patient-queue.entity';
import { CreateQueueTokenDto } from '../dto/create-queue-token.dto';
import { MicroserviceClientService } from './microservice-client.service';

@Injectable()
export class QueueService {
  constructor(
    @InjectRepository(PatientQueue)
    private queueRepository: Repository<PatientQueue>,
    private microserviceClient: MicroserviceClientService,
  ) {}

  async createToken(createQueueTokenDto: CreateQueueTokenDto): Promise<PatientQueue> {
    // Get patient details locally (no external service call needed)
    // const patient = await this.patientService.findOne(createQueueTokenDto.patientId);
    
    // Generate queue number
    const queueNumber = await this.generateQueueNumber(createQueueTokenDto.locationId);
    
    // Calculate estimated wait time
    const estimatedTime = await this.calculateWaitTime(
      createQueueTokenDto.locationId,
      createQueueTokenDto.department,
    );

    const queueToken = this.queueRepository.create({
      ...createQueueTokenDto,
      queueNumber,
      estimatedTime,
      queueType: createQueueTokenDto.department || 'consultation',
    });

    return this.queueRepository.save(queueToken);
  }

  async findAll(locationId: number, status?: string): Promise<PatientQueue[]> {
    const where: any = { locationId };
    if (status) {
      where.status = status;
    }

    return this.queueRepository.find({
      where,
      relations: ['location', 'patient'],
      order: { createdAt: 'ASC' },
    });
  }

  async findOne(id: number): Promise<PatientQueue> {
    const token = await this.queueRepository.findOne({
      where: { id },
      relations: ['location', 'patient'],
    });

    if (!token) {
      throw new NotFoundException(`Queue token with ID ${id} not found`);
    }

    return token;
  }

  async callNext(locationId: number, department?: string): Promise<PatientQueue> {
    const where: any = { locationId, status: 'waiting' };
    if (department) {
      where.queueType = department;
    }

    const nextToken = await this.queueRepository.findOne({
      where,
      order: { createdAt: 'ASC' },
    });

    if (!nextToken) {
      throw new NotFoundException('No waiting tokens found');
    }

    nextToken.status = 'in_progress';
    nextToken.actualTime = new Date();

    return this.queueRepository.save(nextToken);
  }

  async updateStatus(id: number, status: string): Promise<PatientQueue> {
    const token = await this.findOne(id);
    token.status = status;
    
    if (status === 'completed') {
      token.actualTime = new Date();
    }

    return this.queueRepository.save(token);
  }

  async getQueueStats(locationId: number): Promise<any> {
    const total = await this.queueRepository.count({ where: { locationId } });
    const waiting = await this.queueRepository.count({ 
      where: { locationId, status: 'waiting' } 
    });
    const inProgress = await this.queueRepository.count({ 
      where: { locationId, status: 'in_progress' } 
    });
    const completed = await this.queueRepository.count({ 
      where: { locationId, status: 'completed' } 
    });

    return {
      total,
      waiting,
      inProgress,
      completed,
      averageWaitTime: await this.getAverageWaitTime(locationId),
    };
  }

  private async generateQueueNumber(locationId: number): Promise<number> {
    const today = new Date().toISOString().split('T')[0];
    const count = await this.queueRepository
      .createQueryBuilder('queue')
      .where('queue.locationId = :locationId', { locationId })
      .andWhere('DATE(queue.createdAt) = :today', { today })
      .getCount();

    return count + 1;
  }

  private async calculateWaitTime(locationId: number, department?: string): Promise<Date> {
    const where: any = { locationId, status: 'waiting' };
    if (department) {
      where.queueType = department;
    }

    const waitingCount = await this.queueRepository.count({ where });
    const estimatedMinutes = waitingCount * 15; // Assume 15 minutes per patient
    const estimatedTime = new Date();
    estimatedTime.setMinutes(estimatedTime.getMinutes() + estimatedMinutes);
    return estimatedTime;
  }

  private async getAverageWaitTime(locationId: number): Promise<number> {
    const result = await this.queueRepository
      .createQueryBuilder('queue')
      .select('AVG(EXTRACT(EPOCH FROM (queue.actualTime - queue.createdAt))/60)', 'avgWaitTime')
      .where('queue.locationId = :locationId', { locationId })
      .andWhere('queue.actualTime IS NOT NULL')
      .getRawOne();

    return Math.round(result?.avgWaitTime || 0);
  }
}