import { Controller, Get } from '@nestjs/common';
import { VisitTypeService } from '../services/visit-type.service';

@Controller('visit-type')
export class VisitTypeController {
  constructor(private readonly visitTypeService: VisitTypeService) {}

  @Get()
  async findAll() {
    return this.visitTypeService.findAll();
  }
}