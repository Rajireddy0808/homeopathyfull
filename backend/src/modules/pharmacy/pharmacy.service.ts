import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Medicine, Prescription, PrescriptionItem } from './entities/pharmacy.entity';

@Injectable()
export class PharmacyService {
  constructor(
    @InjectRepository(Medicine)
    private medicineRepository: Repository<Medicine>,
    @InjectRepository(Prescription)
    private prescriptionRepository: Repository<Prescription>,
    @InjectRepository(PrescriptionItem)
    private prescriptionItemRepository: Repository<PrescriptionItem>,
  ) {}

  async getPrescriptions(locationId: number) {
    const query = `
      SELECT 
        p.id as prescription_id,
        p.prescription_number,
        p.created_at,
        p.notes,
        pt.first_name || ' ' || pt.last_name as patient_name,
        pt.mobile,
        u.first_name || ' ' || u.last_name as doctor_name,
        COALESCE(
          JSON_AGG(
            JSON_BUILD_OBJECT(
              'medicine_type', pi.medicine_type,
              'medicine', pi.medicine_name,
              'potency', pi.potency,
              'dosage', pi.dosage,
              'morning', pi.morning,
              'afternoon', pi.afternoon,
              'night', pi.night
            )
          ) FILTER (WHERE pi.id IS NOT NULL), 
          '[]'::json
        ) as medicines,
        7 as medicine_days,
        NULL as next_appointment_date,
        p.notes as notes_to_pharmacy
      FROM prescriptions p
      LEFT JOIN patients pt ON p.patient_id = pt.id
      LEFT JOIN users u ON p.doctor_id = u.id
      LEFT JOIN prescription_items pi ON p.id = pi.prescription_id
      WHERE p.location_id = $1 AND p.status = 'pending'
      GROUP BY p.id, p.prescription_number, p.created_at, p.notes, pt.first_name, pt.last_name, pt.mobile, u.first_name, u.last_name
      ORDER BY p.created_at DESC
    `;

    const result = await this.prescriptionRepository.query(query, [locationId]);
    return result;
  }

  async updatePrescriptionStatus(prescriptionId: number, status: number) {
    const statusMap = {
      1: 'dispensed',
      2: 'cancelled'
    };

    await this.prescriptionRepository.update(prescriptionId, {
      status: statusMap[status] as any
    });

    return { message: 'Status updated successfully' };
  }

  async getMedicines(locationId: number) {
    return this.medicineRepository.find({
      where: { locationId, isActive: true },
      order: { name: 'ASC' }
    });
  }
}