import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, ManyToOne, JoinColumn } from 'typeorm';
import { Patient } from './patient.entity';

@Entity('patient_prescriptions')
export class PatientPrescription {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ name: 'patient_id' })
  patientId: number;

  @Column({ name: 'vitals_temperature', type: 'decimal', precision: 4, scale: 1, nullable: true })
  vitalsTemperature: number;

  @Column({ name: 'vitals_blood_pressure', length: 20, nullable: true })
  vitalsBloodPressure: string;

  @Column({ name: 'vitals_heart_rate', nullable: true })
  vitalsHeartRate: number;

  @Column({ name: 'vitals_o2_saturation', type: 'decimal', precision: 5, scale: 2, nullable: true })
  vitalsO2Saturation: number;

  @Column({ name: 'vitals_respiratory_rate', nullable: true })
  vitalsRespiratoryRate: number;

  @Column({ name: 'vitals_weight', type: 'decimal', precision: 5, scale: 2, nullable: true })
  vitalsWeight: number;

  @Column({ name: 'vitals_height', nullable: true })
  vitalsHeight: number;

  @Column({ name: 'vitals_blood_glucose', nullable: true })
  vitalsBloodGlucose: number;

  @Column({ name: 'vitals_pain_scale', nullable: true })
  vitalsPainScale: number;

  @Column({ name: 'nursing_notes', type: 'text', nullable: true })
  nursingNotes: string;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;
}