import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { VisitType } from '../entities/visit-type.entity';

@Injectable()
export class VisitTypeService {
  constructor(
    @InjectRepository(VisitType)
    private visitTypeRepository: Repository<VisitType>,
  ) {}

  async findAll() {
    return this.visitTypeRepository.find({ where: { is_active: true } });
  }
}