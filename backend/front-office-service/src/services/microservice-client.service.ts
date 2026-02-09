import { Injectable, HttpException, HttpStatus } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';


@Injectable()
export class MicroserviceClientService {
  constructor(private configService: ConfigService) {}

  private getServiceUrl(serviceName: string): string {
    const urls = {
      user: this.configService.get('USER_SERVICE_URL'),
      // patient: 'http://localhost:3003', // This service itself
      billing: this.configService.get('BILLING_SERVICE_URL'),
      appointment: this.configService.get('APPOINTMENT_SERVICE_URL'),
      clinical: this.configService.get('CLINICAL_SERVICE_URL'),
      laboratory: this.configService.get('LABORATORY_SERVICE_URL'),
      pharmacy: this.configService.get('PHARMACY_SERVICE_URL'),
    };
    return urls[serviceName];
  }

  async get(serviceName: string, endpoint: string, headers?: any): Promise<any> {
    try {
      const baseUrl = this.getServiceUrl(serviceName);
      const response = await fetch(`${baseUrl}${endpoint}`, { 
        headers: { 'Content-Type': 'application/json', ...headers } 
      });
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}`);
      }
      return response.json();
    } catch (error) {
      throw new HttpException(
        `Error communicating with ${serviceName} service: ${error.message}`,
        HttpStatus.SERVICE_UNAVAILABLE,
      );
    }
  }

  async post(serviceName: string, endpoint: string, data: any, headers?: any): Promise<any> {
    try {
      const baseUrl = this.getServiceUrl(serviceName);
      const response = await fetch(`${baseUrl}${endpoint}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', ...headers },
        body: JSON.stringify(data)
      });
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}`);
      }
      return response.json();
    } catch (error) {
      throw new HttpException(
        `Error communicating with ${serviceName} service: ${error.message}`,
        HttpStatus.SERVICE_UNAVAILABLE,
      );
    }
  }

  async put(serviceName: string, endpoint: string, data: any, headers?: any): Promise<any> {
    try {
      const baseUrl = this.getServiceUrl(serviceName);
      const response = await fetch(`${baseUrl}${endpoint}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json', ...headers },
        body: JSON.stringify(data)
      });
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}`);
      }
      return response.json();
    } catch (error) {
      throw new HttpException(
        `Error communicating with ${serviceName} service: ${error.message}`,
        HttpStatus.SERVICE_UNAVAILABLE,
      );
    }
  }

  async delete(serviceName: string, endpoint: string, headers?: any): Promise<any> {
    try {
      const baseUrl = this.getServiceUrl(serviceName);
      const response = await fetch(`${baseUrl}${endpoint}`, {
        method: 'DELETE',
        headers: { 'Content-Type': 'application/json', ...headers }
      });
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}`);
      }
      return response.json();
    } catch (error) {
      throw new HttpException(
        `Error communicating with ${serviceName} service: ${error.message}`,
        HttpStatus.SERVICE_UNAVAILABLE,
      );
    }
  }

  // Specific service methods
  // getPatient is handled locally by this service - no external call needed

  async createBill(billData: any, headers?: any) {
    return this.post('billing', '/api/bills', billData, headers);
  }

  async getAppointments(patientId: number, headers?: any) {
    return this.get('appointment', `/api/appointments?patientId=${patientId}`, headers);
  }

  async createAppointment(appointmentData: any, headers?: any) {
    return this.post('appointment', '/api/appointments', appointmentData, headers);
  }

  async getServices(locationId: number, headers?: any) {
    return this.get('billing', `/api/services?locationId=${locationId}`, headers);
  }

  async getPackages(locationId: number, headers?: any) {
    return this.get('billing', `/api/packages?locationId=${locationId}`, headers);
  }
}