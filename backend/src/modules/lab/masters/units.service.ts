import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Unit } from './entities/unit.entity';
import { CreateUnitDto, UpdateUnitDto } from './dto/unit.dto';

@Injectable()
export class UnitsService {
  constructor(
    @InjectRepository(Unit)
    private unitsRepository: Repository<Unit>,
  ) {}

  async findAll(locationId?: number): Promise<Unit[]> {
    const where = locationId ? { locationId } : {};
    return this.unitsRepository.find({
      where,
      order: { id: 'ASC' }
    });
  }

  async create(createUnitDto: CreateUnitDto): Promise<Unit> {
    const unit = this.unitsRepository.create({
      code: createUnitDto.code,
      description: createUnitDto.description,
      status: createUnitDto.isActive ? '1' : '0',
      locationId: createUnitDto.locationId,
    });
    
    return this.unitsRepository.save(unit);
  }

  async update(id: number, updateUnitDto: UpdateUnitDto): Promise<Unit> {
    const unit = await this.unitsRepository.findOne({ where: { id } });
    
    if (!unit) {
      throw new Error('Unit not found');
    }
    
    if (updateUnitDto.code) unit.code = updateUnitDto.code;
    if (updateUnitDto.description) unit.description = updateUnitDto.description;
    if (updateUnitDto.isActive !== undefined) unit.status = updateUnitDto.isActive ? '1' : '0';
    if (updateUnitDto.locationId) unit.locationId = updateUnitDto.locationId;
    
    return this.unitsRepository.save(unit);
  }

  async remove(id: number): Promise<void> {
    const result = await this.unitsRepository.delete(id);
    
    if (result.affected === 0) {
      throw new Error('Unit not found');
    }
  }
}