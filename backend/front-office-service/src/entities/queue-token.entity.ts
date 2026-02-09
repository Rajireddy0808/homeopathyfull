import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne, JoinColumn } from 'typeorm';
import { Location } from './location.entity';

@Entity('queue_tokens')
export class QueueToken {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ name: 'token_number', length: 20 })
  tokenNumber: string;

  @Column({ name: 'patient_id' })
  patientId: number;

  @Column({ name: 'appointment_id', nullable: true })
  appointmentId: number;

  @Column({ length: 100, nullable: true })
  department: string;

  @Column({ name: 'priority_level', default: 1 })
  priorityLevel: number;

  @Column({ name: 'estimated_wait_time', nullable: true })
  estimatedWaitTime: number;

  @Column({ 
    default: 'waiting',
    enum: ['waiting', 'called', 'completed', 'cancelled']
  })
  status: string;

  @Column({ name: 'location_id' })
  locationId: number;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @Column({ name: 'called_at', nullable: true })
  calledAt: Date;

  @Column({ name: 'completed_at', nullable: true })
  completedAt: Date;

  @ManyToOne(() => Location)
  @JoinColumn({ name: 'location_id' })
  location: Location;
}