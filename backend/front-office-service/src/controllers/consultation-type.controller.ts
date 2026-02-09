import { Controller, Get } from '@nestjs/common';
import { ConsultationTypeService } from '../services/consultation-type.service';

@Controller('consultation-type')
export class ConsultationTypeController {
  constructor(private readonly consultationTypeService: ConsultationTypeService) {}

  @Get()
  async findAll() {
    return this.consultationTypeService.findAll();
  }
}