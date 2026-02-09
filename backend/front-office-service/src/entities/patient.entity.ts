import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn } from 'typeorm';

@Entity('patients')
export class Patient {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ name: 'patient_unique_id', length: 20, nullable: true })
  patientId: string;

  @Column({ name: 'first_name', length: 50 })
  firstName: string;

  @Column({ name: 'last_name', length: 50 })
  lastName: string;

  @Column({ name: 'date_of_birth', type: 'date' })
  dateOfBirth: Date;

  @Column({ length: 10 })
  gender: string;

  @Column({ length: 15 })
  phone: string;

  @Column({ length: 100, nullable: true })
  email: string;

  @Column('text')
  address: string;

  @Column({ name: 'emergency_contact', length: 15, nullable: true })
  emergencyContact: string;

  @Column({ name: 'blood_group', length: 5, nullable: true })
  bloodGroup: string;

  @Column('text', { nullable: true })
  allergies: string;

  @Column({ name: 'medical_history', type: 'text', nullable: true })
  medicalHistory: string;

  @Column({ name: 'insurance_number', length: 50, nullable: true })
  insuranceNumber: string;

  @Column({ name: 'is_active', default: true })
  isActive: boolean;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;

  // Location relationship removed - managed by settings service
  // @ManyToOne(() => Location)
  // @JoinColumn({ name: 'location_id' })
  // location: Location;
}