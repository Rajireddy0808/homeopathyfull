import { Controller, Get, Post, Body, Param, Query, UseGuards } from '@nestjs/common';
import { PatientService } from '../services/patient.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@Controller('api/patients')
@UseGuards(JwtAuthGuard)
export class PatientController {
  constructor(private readonly patientService: PatientService) {}

  @Get()
  findAll() {
    return this.patientService.findAll();
  }

  @Get('search')
  searchPatients(
    @Query('query') query: string,
  ) {
    return this.patientService.searchPatients(query);
  }

  @Post('search')
  searchPatientsPost(
    @Body() body: { query: string },
  ) {
    console.log('POST search body:', body);
    return this.patientService.searchPatients(body.query);
  }



  @Get('stats')
  getStats() {
    return this.patientService.getPatientStats();
  }

  @Get(':id')
  findOne(@Param('id') id: number) {
    return this.patientService.findOne(id);
  }

  @Get(':id/history')
  getHistory(@Param('id') id: number) {
    return this.patientService.getPatientHistory(id);
  }
}