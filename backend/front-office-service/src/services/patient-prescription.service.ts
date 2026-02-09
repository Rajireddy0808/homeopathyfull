import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { PatientPrescription } from '../entities/patient-prescription.entity';

@Injectable()
export class PatientPrescriptionService {
  constructor(
    @InjectRepository(PatientPrescription)
    private prescriptionRepository: Repository<PatientPrescription>,
  ) {}

  async createVitals(vitalsData: {
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
  }): Promise<PatientPrescription> {
    const prescription = this.prescriptionRepository.create(vitalsData);
    return this.prescriptionRepository.save(prescription);
  }

  async getPatientVitals(patientId: number): Promise<PatientPrescription[]> {
    return this.prescriptionRepository.find({
      where: { patientId },
      order: { createdAt: 'DESC' },
    });
  }
}