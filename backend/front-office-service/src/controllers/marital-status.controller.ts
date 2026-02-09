import { Controller, Get } from '@nestjs/common';
import { MaritalStatusService } from '../services/marital-status.service';

@Controller('marital-status')
export class MaritalStatusController {
  constructor(private readonly maritalStatusService: MaritalStatusService) {}

  @Get()
  async findAll() {
    return this.maritalStatusService.findAll();
  }
}