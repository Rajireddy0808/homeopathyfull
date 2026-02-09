import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { PatientCategory } from '../entities/patient-category.entity';

@Injectable()
export class PatientCategoryService {
  constructor(
    @InjectRepository(PatientCategory)
    private patientCategoryRepository: Repository<PatientCategory>,
  ) {}

  async findAll() {
    return this.patientCategoryRepository.find({ where: { is_active: true } });
  }
}