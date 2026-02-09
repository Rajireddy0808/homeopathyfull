import { Controller, Get, Post, Body, Patch, Param, Delete, UseGuards, Query } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiHeader } from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { PatientsService } from './patients.service';
import { Patient } from './entities/patient.entity';
import { CurrentLocation } from '../../common/decorators/location.decorator';

@ApiTags('Patients')
@ApiBearerAuth()
@ApiHeader({ name: 'x-location-id', description: 'Location ID', required: true })
@UseGuards(JwtAuthGuard)
@Controller('patients')
export class PatientsController {
  constructor(private readonly patientsService: PatientsService) {}

  @Post()
  @ApiOperation({ summary: 'Create a new patient' })
  create(@Body() createPatientDto: Partial<Patient>) {
    return this.patientsService.create(createPatientDto);
  }

  @Get()
  @ApiOperation({ summary: 'Get all patients' })
  findAll(
    @CurrentLocation() locationId: string,
    @Query('patient_source_id') patientSourceId?: string,
    @Query('from_date') fromDate?: string,
    @Query('to_date') toDate?: string
  ) {
    return this.patientsService.findAll(locationId, patientSourceId, fromDate, toDate);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get patient by ID' })
  findOne(@Param('id') id: string) {
    return this.patientsService.findOne(id);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update patient' })
  update(@Param('id') id: string, @Body() updatePatientDto: Partial<Patient>) {
    return this.patientsService.update(id, updatePatientDto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete patient' })
  remove(@Param('id') id: string) {
    return this.patientsService.remove(id);
  }

  @Post('register')
  @ApiOperation({ summary: 'Register patient with consultation and billing' })
  register(@Body() registerData: any, @CurrentLocation() locationId: string) {
    return this.patientsService.registerPatient(registerData, locationId);
  }

  @Post('consultation')
  @ApiOperation({ summary: 'Create consultation' })
  createConsultation(@Body() consultationData: any, @CurrentLocation() locationId: string) {
    return this.patientsService.createConsultation(consultationData, locationId);
  }

  @Post('bill')
  @ApiOperation({ summary: 'Create bill' })
  createBill(@Body() billData: any, @CurrentLocation() locationId: string) {
    return this.patientsService.createBill(billData, locationId);
  }
}