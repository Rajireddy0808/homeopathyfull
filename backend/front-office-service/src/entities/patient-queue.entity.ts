import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn } from 'typeorm';

@Entity('patient_queue')
export class PatientQueue {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ name: 'location_id' })
  locationId: number;

  @Column({ name: 'patient_id' })
  patientId: number;

  @Column({ name: 'appointment_id', nullable: true })
  appointmentId: number;

  @Column({ name: 'queue_number' })
  queueNumber: number;

  @Column({ name: 'queue_type', length: 20 })
  queueType: string;

  @Column({ 
    default: 'waiting',
    enum: ['waiting', 'in_progress', 'completed', 'cancelled']
  })
  status: string;

  @Column({ name: 'estimated_time', nullable: true })
  estimatedTime: Date;

  @Column({ name: 'actual_time', nullable: true })
  actualTime: Date;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;

  // Foreign key relationships removed - managed by respective services
  // @ManyToOne(() => Location)
  // @JoinColumn({ name: 'location_id' })
  // location: Location;

  // @ManyToOne(() => Patient)
  // @JoinColumn({ name: 'patient_id' })
  // patient: Patient;
}