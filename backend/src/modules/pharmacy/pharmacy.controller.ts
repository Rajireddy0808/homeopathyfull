import { Controller, Get, Post, Put, Body, Param, Query, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { PharmacyService } from './pharmacy.service';

@Controller('pharmacy')
@UseGuards(JwtAuthGuard)
export class PharmacyController {
  constructor(private readonly pharmacyService: PharmacyService) {}

  @Get('prescriptions')
  async getPrescriptions(@Query('location_id') locationId: number) {
    return this.pharmacyService.getPrescriptions(locationId);
  }

  @Put('prescriptions/:id/status')
  async updatePrescriptionStatus(
    @Param('id') id: number,
    @Body('status') status: number
  ) {
    return this.pharmacyService.updatePrescriptionStatus(id, status);
  }

  @Get('medicines')
  async getMedicines(@Query('location_id') locationId: number) {
    return this.pharmacyService.getMedicines(locationId);
  }
}