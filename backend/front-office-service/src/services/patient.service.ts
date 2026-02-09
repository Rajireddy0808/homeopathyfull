import { Injectable, NotFoundException, OnModuleInit } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Like } from 'typeorm';
import { Patient } from '../entities/patient.entity';
import { MicroserviceClientService } from './microservice-client.service';

@Injectable()
export class PatientService implements OnModuleInit {
  constructor(
    @InjectRepository(Patient)
    private patientRepository: Repository<Patient>,
    private microserviceClient: MicroserviceClientService,
  ) {}

  async onModuleInit() {
    await this.generateMissingPatientIds();
  }

  private async generateMissingPatientIds(): Promise<void> {
    const patientsWithoutId = await this.patientRepository.find({
      where: { patientId: null },
    });

    for (const patient of patientsWithoutId) {
      patient.patientId = await this.generatePatientId();
      await this.patientRepository.save(patient);
    }
  }

  private async generatePatientId(): Promise<string> {
    const year = new Date().getFullYear().toString().slice(-2);
    
    const lastPatient = await this.patientRepository
      .createQueryBuilder('patient')
      .where('patient.patient_unique_id IS NOT NULL')
      .orderBy('patient.id', 'DESC')
      .getOne();

    let sequence = 1;
    if (lastPatient?.patientId) {
      const lastSequence = parseInt(lastPatient.patientId.slice(-2));
      sequence = lastSequence + 1;
    }

    return `P${year}${sequence.toString().padStart(4, '0')}`;
  }

  async findAll(): Promise<Patient[]> {
    return this.patientRepository.find({
      where: { isActive: true },
      order: { createdAt: 'DESC' },
    });
  }

  async findOne(id: number): Promise<Patient> {
    const patient = await this.patientRepository.findOne({
      where: { id },
    });

    if (!patient) {
      throw new NotFoundException(`Patient with ID ${id} not found`);
    }

    return patient;
  }

  async searchPatients(query: string): Promise<any[]> {
    console.log('Search params:', { query });
    
    const whereConditions: any[] = [
      { firstName: Like(`%${query}%`), isActive: true },
      { lastName: Like(`%${query}%`), isActive: true },
      { phone: Like(`%${query}%`), isActive: true },
      { patientId: Like(`%${query}%`), isActive: true },
    ];
    
    console.log('Where conditions:', whereConditions);

    const filteredPatients = await this.patientRepository.find({
      where: whereConditions,
      take: 20,
    });
    
    console.log('Found patients:', filteredPatients.length);

    return filteredPatients.map(patient => ({
      id: patient.patientId || patient.id.toString(),
      name: `${patient.firstName} ${patient.lastName}`,
      age: this.calculateAge(patient.dateOfBirth),
      gender: patient.gender,
      phone: patient.phone,
      tokenNumber: `T${patient.id.toString().padStart(3, '0')}`,
      address: patient.address,
      allergies: patient.allergies ? patient.allergies.split(',').map(a => a.trim()) : []
    }));
  }

  private calculateAge(dateOfBirth: Date): number {
    const today = new Date();
    const birthDate = new Date(dateOfBirth);
    let age = today.getFullYear() - birthDate.getFullYear();
    const monthDiff = today.getMonth() - birthDate.getMonth();
    
    if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
      age--;
    }
    
    return age;
  }



  async getPatientHistory(patientId: number): Promise<any> {
    const patient = await this.findOne(patientId);
    
    try {
      const [appointments, bills, labOrders] = await Promise.all([
        this.microserviceClient.get('appointment', `/api/appointments?patientId=${patientId}`),
        this.microserviceClient.get('billing', `/api/bills?patientId=${patientId}`),
        this.microserviceClient.get('laboratory', `/api/lab-orders?patientId=${patientId}`),
      ]);

      return {
        patient,
        appointments: appointments || [],
        bills: bills || [],
        labOrders: labOrders || [],
      };
    } catch (error) {
      return {
        patient,
        appointments: [],
        bills: [],
        labOrders: [],
        error: 'Some services are unavailable',
      };
    }
  }

  async create(patientData: Partial<Patient>): Promise<Patient> {
    const patient = this.patientRepository.create(patientData);
    
    if (!patient.patientId) {
      patient.patientId = await this.generatePatientId();
    }
    
    return this.patientRepository.save(patient);
  }

  async update(id: number, patientData: Partial<Patient>): Promise<Patient> {
    await this.patientRepository.update(id, patientData);
    return this.findOne(id);
  }

  async getPatientStats(): Promise<any> {
    const total = await this.patientRepository.count({ 
      where: { isActive: true } 
    });
    
    const today = new Date().toISOString().split('T')[0];
    const newToday = await this.patientRepository
      .createQueryBuilder('patient')
      .where('DATE(patient.createdAt) = :today', { today })
      .getCount();

    return {
      totalPatients: total,
      newPatientsToday: newToday,
    };
  }
}