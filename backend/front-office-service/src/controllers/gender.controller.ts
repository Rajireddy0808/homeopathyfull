import { Controller, Get } from '@nestjs/common';
import { GenderService } from '../services/gender.service';

@Controller('gender')
export class GenderController {
  constructor(private readonly genderService: GenderService) {}

  @Get()
  async findAll() {
    return this.genderService.findAll();
  }
}