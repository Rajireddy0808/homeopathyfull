import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ConsultationType } from '../entities/consultation-type.entity';

@Injectable()
export class ConsultationTypeService {
  constructor(
    @InjectRepository(ConsultationType)
    private consultationTypeRepository: Repository<ConsultationType>,
  ) {}

  async findAll() {
    return this.consultationTypeRepository.find({ where: { is_active: true } });
  }
}