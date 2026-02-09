import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Investigation } from './entities/investigation.entity';
import { CreateInvestigationDto, UpdateInvestigationDto } from './dto/investigation.dto';

@Injectable()
export class InvestigationsService {
  constructor(
    @InjectRepository(Investigation)
    private investigationsRepository: Repository<Investigation>,
  ) {}

  async findAll(locationId?: number): Promise<Investigation[]> {
    const queryBuilder = this.investigationsRepository.createQueryBuilder('investigation')
      .leftJoin('units', 'unit', 'investigation.unit_id = unit.id')
      .select([
        'investigation.id as id',
        'investigation.code as code', 
        'investigation.description as description',
        'investigation.method as method',
        'investigation.unit_id as unitId',
        'investigation.result_type as resultType',
        'investigation.default_value as defaultValue',
        'investigation.location_id as locationId',
        'investigation.status as status',
        'investigation.created_at as createdAt',
        'investigation.updated_at as updatedAt',
        'unit.description as unitDescription'
      ]);
    
    if (locationId) {
      queryBuilder.where('investigation.location_id = :locationId', { locationId });
    }
    
    return queryBuilder.orderBy('investigation.id', 'ASC').getRawMany();
  }

  async create(createInvestigationDto: CreateInvestigationDto): Promise<Investigation> {
    const investigation = this.investigationsRepository.create({
      code: createInvestigationDto.code,
      description: createInvestigationDto.description,
      method: createInvestigationDto.method,
      unitId: createInvestigationDto.unitId,
      resultType: createInvestigationDto.resultType,
      defaultValue: createInvestigationDto.defaultValue,
      locationId: createInvestigationDto.locationId,
      status: createInvestigationDto.isActive ? '1' : '0',
    });
    
    return this.investigationsRepository.save(investigation);
  }

  async update(id: number, updateInvestigationDto: UpdateInvestigationDto): Promise<Investigation> {
    const investigation = await this.investigationsRepository.findOne({ where: { id } });
    
    if (!investigation) {
      throw new Error('Investigation not found');
    }
    
    if (updateInvestigationDto.code) investigation.code = updateInvestigationDto.code;
    if (updateInvestigationDto.description) investigation.description = updateInvestigationDto.description;
    if (updateInvestigationDto.method !== undefined) investigation.method = updateInvestigationDto.method;
    if (updateInvestigationDto.unitId !== undefined) investigation.unitId = updateInvestigationDto.unitId;
    if (updateInvestigationDto.resultType !== undefined) investigation.resultType = updateInvestigationDto.resultType;
    if (updateInvestigationDto.defaultValue !== undefined) investigation.defaultValue = updateInvestigationDto.defaultValue;
    if (updateInvestigationDto.locationId) investigation.locationId = updateInvestigationDto.locationId;
    if (updateInvestigationDto.isActive !== undefined) investigation.status = updateInvestigationDto.isActive ? '1' : '0';
    
    return this.investigationsRepository.save(investigation);
  }

  async remove(id: number): Promise<void> {
    const result = await this.investigationsRepository.delete(id);
    
    if (result.affected === 0) {
      throw new Error('Investigation not found');
    }
  }
}