import { Controller, Get } from '@nestjs/common';
import { BloodGroupService } from '../services/blood-group.service';

@Controller('blood-group')
export class BloodGroupController {
  constructor(private readonly bloodGroupService: BloodGroupService) {}

  @Get()
  async findAll() {
    return this.bloodGroupService.findAll();
  }
}