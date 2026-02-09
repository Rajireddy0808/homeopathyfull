import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, DataSource } from 'typeorm';
import { Patient } from './entities/patient.entity';

@Injectable()
export class PatientsService {
  constructor(
    @InjectRepository(Patient)
    private patientRepository: Repository<Patient>,
    private dataSource: DataSource,
  ) {}

  async create(patientData: Partial<Patient>): Promise<Patient> {
    const patientId = await this.generatePatientId(patientData.locationId);
    const patient = this.patientRepository.create({
      ...patientData,
      patientId,
    });
    return this.patientRepository.save(patient);
  }

  async findAll(locationId: string, patientSourceId?: string, fromDate?: string, toDate?: string): Promise<Patient[]> {
    let query = this.patientRepository.createQueryBuilder('patient')
      .where('patient.locationId = :locationId', { locationId: parseInt(locationId) });
    
    if (patientSourceId) {
      query = query.andWhere('patient.patientSourceId = :patientSourceId', { patientSourceId: parseInt(patientSourceId) });
    }
    
    if (fromDate) {
      query = query.andWhere('DATE(patient.createdAt) >= :fromDate', { fromDate });
    }
    
    if (toDate) {
      query = query.andWhere('DATE(patient.createdAt) <= :toDate', { toDate });
    }
    
    console.log('Query SQL:', query.getSql());
    console.log('Query Parameters:', { locationId, patientSourceId, fromDate, toDate });
    
    return query.orderBy('patient.createdAt', 'DESC').getMany();
  }

  async findOne(id: string): Promise<Patient> {
    return this.patientRepository.findOne({ where: { id: parseInt(id) } });
  }

  async update(id: string, updateData: Partial<Patient>): Promise<Patient> {
    await this.patientRepository.update(parseInt(id), updateData);
    return this.findOne(id);
  }

  async remove(id: string): Promise<void> {
    await this.patientRepository.delete(parseInt(id));
  }

  private async generatePatientId(locationId: number): Promise<string> {
    const count = await this.patientRepository.count({ where: { locationId } });
    return `PAT${(count + 1).toString().padStart(6, '0')}`;
  }

  async registerPatient(registerData: any, locationId: string): Promise<any> {
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      // Generate patient ID
      const patientCount = await queryRunner.query(
        'SELECT COUNT(*) as count FROM patients WHERE location_id = $1',
        [locationId]
      );
      const patientId = `PAT${(parseInt(patientCount[0].count) + 1).toString().padStart(6, '0')}`;

      // Insert patient
      const patientResult = await queryRunner.query(`
        INSERT INTO patients (patient_id, first_name, last_name, date_of_birth, gender, 
                            phone, email, address, emergency_contact, blood_group, 
                            allergies, medical_history, location_id)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)
        RETURNING id
      `, [
        patientId, registerData.patient.first_name, registerData.patient.last_name,
        registerData.patient.date_of_birth, registerData.patient.gender,
        registerData.patient.phone, registerData.patient.email,
        registerData.patient.address, registerData.patient.emergency_contact,
        registerData.patient.blood_group, registerData.patient.allergies,
        registerData.patient.medical_history, locationId
      ]);

      const newPatientId = patientResult[0].id;

      // Create consultation if provided
      let consultationId = null;
      if (registerData.consultation) {
        const consultationCount = await queryRunner.query(
          'SELECT COUNT(*) as count FROM consultations WHERE location_id = $1',
          [locationId]
        );
        const consultationNumber = `CON${(parseInt(consultationCount[0].count) + 1).toString().padStart(6, '0')}`;

        const consultationResult = await queryRunner.query(`
          INSERT INTO consultations (consultation_id, patient_id, doctor_id, 
                                   chief_complaint, diagnosis, treatment_plan, 
                                   consultation_fee, location_id)
          VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
          RETURNING id
        `, [
          consultationNumber, newPatientId, registerData.consultation.doctor_id,
          registerData.consultation.chief_complaint, registerData.consultation.diagnosis,
          registerData.consultation.treatment_plan, registerData.consultation.consultation_fee,
          locationId
        ]);

        consultationId = consultationResult[0].id;
      }

      // Create bill if provided
      if (registerData.bill) {
        const billCount = await queryRunner.query(
          'SELECT COUNT(*) as count FROM bills WHERE location_id = $1',
          [locationId]
        );
        const billNumber = `BILL${(parseInt(billCount[0].count) + 1).toString().padStart(6, '0')}`;

        const billResult = await queryRunner.query(`
          INSERT INTO bills (bill_id, patient_id, consultation_id, total_amount, 
                           discount_amount, tax_amount, net_amount, payment_method, 
                           payment_status, location_id, created_by)
          VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
          RETURNING id
        `, [
          billNumber, newPatientId, consultationId, registerData.bill.total_amount,
          registerData.bill.discount_amount || 0, registerData.bill.tax_amount || 0,
          registerData.bill.net_amount, registerData.bill.payment_method,
          registerData.bill.payment_status || 'completed', locationId,
          registerData.bill.created_by
        ]);

        const billId = billResult[0].id;

        // Insert bill items
        if (registerData.bill.items) {
          for (const item of registerData.bill.items) {
            await queryRunner.query(`
              INSERT INTO bill_items (bill_id, item_name, item_type, quantity, unit_price, total_price)
              VALUES ($1, $2, $3, $4, $5, $6)
            `, [billId, item.item_name, item.item_type || 'consultation', 
                item.quantity || 1, item.unit_price, item.total_price]);
          }
        }

        // Create payment transaction
        if (registerData.bill.payment_method) {
          const transactionNumber = `TXN${Date.now()}`;
          await queryRunner.query(`
            INSERT INTO payment_transactions (transaction_id, bill_id, amount, 
                                           payment_method, payment_status, created_by)
            VALUES ($1, $2, $3, $4, $5, $6)
          `, [transactionNumber, billId, registerData.bill.net_amount,
              registerData.bill.payment_method, 'completed', registerData.bill.created_by]);
        }
      }

      await queryRunner.commitTransaction();

      return {
        success: true,
        patient_id: patientId,
        message: 'Patient registered successfully'
      };

    } catch (error) {
      await queryRunner.rollbackTransaction();
      throw error;
    } finally {
      await queryRunner.release();
    }
  }

  async createConsultation(consultationData: any, locationId: string): Promise<any> {
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();

    try {
      const consultationCount = await queryRunner.query(
        'SELECT COUNT(*) as count FROM consultations WHERE location_id = $1',
        [locationId]
      );
      const consultationNumber = `CON${(parseInt(consultationCount[0].count) + 1).toString().padStart(6, '0')}`;

      const result = await queryRunner.query(`
        INSERT INTO consultations (consultation_id, patient_id, doctor_id, 
                                 chief_complaint, diagnosis, treatment_plan, 
                                 consultation_fee, location_id)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
        RETURNING *
      `, [
        consultationNumber, consultationData.patient_id, consultationData.doctor_id,
        consultationData.chief_complaint, consultationData.diagnosis,
        consultationData.treatment_plan, consultationData.consultation_fee, locationId
      ]);

      return { success: true, consultation: result[0] };
    } catch (error) {
      throw error;
    } finally {
      await queryRunner.release();
    }
  }

  async createBill(billData: any, locationId: string): Promise<any> {
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      const billCount = await queryRunner.query(
        'SELECT COUNT(*) as count FROM bills WHERE location_id = $1',
        [locationId]
      );
      const billNumber = `BILL${(parseInt(billCount[0].count) + 1).toString().padStart(6, '0')}`;

      const billResult = await queryRunner.query(`
        INSERT INTO bills (bill_id, patient_id, consultation_id, total_amount, 
                         net_amount, payment_method, payment_status, location_id, created_by)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
        RETURNING id
      `, [
        billNumber, billData.patient_id, billData.consultation_id,
        billData.total_amount, billData.net_amount, billData.payment_method,
        billData.payment_status || 'completed', locationId, billData.created_by
      ]);

      const billId = billResult[0].id;

      // Insert bill items
      if (billData.items) {
        for (const item of billData.items) {
          await queryRunner.query(`
            INSERT INTO bill_items (bill_id, item_name, unit_price, total_price)
            VALUES ($1, $2, $3, $4)
          `, [billId, item.item_name, item.unit_price, item.total_price]);
        }
      }

      await queryRunner.commitTransaction();
      return { success: true, bill_id: billNumber };

    } catch (error) {
      await queryRunner.rollbackTransaction();
      throw error;
    } finally {
      await queryRunner.release();
    }
  }
}