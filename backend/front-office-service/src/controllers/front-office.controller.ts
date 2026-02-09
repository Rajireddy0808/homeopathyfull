import { Controller, Get, Post, Body, Query, UseGuards } from '@nestjs/common';
import { MicroserviceClientService } from '../services/microservice-client.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@Controller('api/front-office')
// @UseGuards(JwtAuthGuard) // Temporarily disabled
export class FrontOfficeController {
  constructor(private readonly microserviceClient: MicroserviceClientService) {}

  @Get('dashboard')
  async getDashboard(@Query('locationId') locationId: number) {
    try {
      // Get data from multiple services
      const [appointments, queueStats] = await Promise.all([
        this.microserviceClient.get('appointment', `/api/appointments?locationId=${locationId}&date=${new Date().toISOString().split('T')[0]}`),
        this.microserviceClient.get('front-office', `/api/queue/stats?locationId=${locationId}`),
      ]);

      return {
        appointments: appointments || [],
        queueStats: queueStats || {},
        todayDate: new Date().toISOString().split('T')[0],
      };
    } catch (error) {
      return {
        appointments: [],
        queueStats: {},
        todayDate: new Date().toISOString().split('T')[0],
        error: 'Some services are unavailable',
      };
    }
  }

  @Get('patient-search')
  async searchPatients(
    @Query('query') query: string,
    @Query('locationId') locationId: number,
  ) {
    return this.microserviceClient.get('patient', `/api/patients/search?query=${query}&locationId=${locationId}`);
  }

  @Get('services')
  async getServices(@Query('locationId') locationId: number) {
    // Mock services data for testing
    return [
      { id: "S001", name: "General Consultation", price: 500, category: "Consultation" },
      { id: "S002", name: "Cardiology Consultation", price: 800, category: "Consultation" },
      { id: "S003", name: "Blood Test - Complete", price: 300, category: "Laboratory" },
      { id: "S004", name: "X-Ray Chest", price: 400, category: "Radiology" },
      { id: "S005", name: "ECG", price: 200, category: "Investigation" },
    ];
  }

  @Get('packages')
  async getPackages(@Query('locationId') locationId: number) {
    return this.microserviceClient.getPackages(locationId);
  }

  @Post('quick-appointment')
  async createQuickAppointment(@Body() appointmentData: any) {
    return this.microserviceClient.createAppointment(appointmentData);
  }

  @Get('patient/:id/history')
  async getPatientHistory(@Query('patientId') patientId: number) {
    try {
      // Get patient locally since this IS the patient service
      const patient = { id: patientId, name: 'Patient Data' }; // Replace with actual patient service call
      
      const [appointments, bills] = await Promise.all([
        this.microserviceClient.getAppointments(patientId),
        this.microserviceClient.get('billing', `/api/bills?patientId=${patientId}`),
      ]);

      return {
        patient,
        appointments: appointments || [],
        bills: bills || [],
      };
    } catch (error) {
      throw error;
    }
  }
}