import { Controller, Get } from '@nestjs/common';
import { PatientCategoryService } from '../services/patient-category.service';

@Controller('patient-category')
export class PatientCategoryController {
  constructor(private readonly patientCategoryService: PatientCategoryService) {}

  @Get()
  async findAll() {
    return this.patientCategoryService.findAll();
  }
}