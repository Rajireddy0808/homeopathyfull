import { Controller, Post, Get, Body, Param, UseGuards } from '@nestjs/common';
import { PatientPrescriptionService } from '../services/patient-prescription.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@Controller('api/patient-prescriptions')
// @UseGuards(JwtAuthGuard) // Temporarily disabled for testing
export class PatientPrescriptionController {
  constructor(private readonly prescriptionService: PatientPrescriptionService) {}

  @Post('vitals')
  createVitals(@Body() vitalsData: {
    patientId: number;
    vitalsTemperature?: number;
    vitalsBloodPressure?: string;
    vitalsHeartRate?: number;
    vitalsO2Saturation?: number;
    vitalsRespiratoryRate?: number;
    vitalsWeight?: number;
    vitalsHeight?: number;
    vitalsBloodGlucose?: number;
    vitalsPainScale?: number;
    nursingNotes?: string;
  }) {
    console.log('Vitals endpoint hit with data:', vitalsData);
    return this.prescriptionService.createVitals(vitalsData);
  }

  @Get(':patientId/vitals')
  getPatientVitals(@Param('patientId') patientId: number) {
    return this.prescriptionService.getPatientVitals(patientId);
  }
}