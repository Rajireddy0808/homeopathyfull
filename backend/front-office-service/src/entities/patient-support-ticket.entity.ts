import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn } from 'typeorm';

@Entity('patient_support_tickets')
export class PatientSupportTicket {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ name: 'ticket_number', length: 20 })
  ticketNumber: string;

  @Column({ name: 'patient_id' })
  patientId: number;

  @Column({ name: 'location_id' })
  locationId: number;

  @Column({ length: 200 })
  subject: string;

  @Column('text')
  description: string;

  @Column({ 
    default: 'medium',
    enum: ['low', 'medium', 'high', 'urgent']
  })
  priority: string;

  @Column({ 
    default: 'open',
    enum: ['open', 'in_progress', 'resolved', 'closed']
  })
  status: string;

  @Column({ name: 'assigned_to', nullable: true })
  assignedTo: number;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;

  // Foreign key relationships removed - managed by respective services
  // @ManyToOne(() => Patient)
  // @JoinColumn({ name: 'patient_id' })
  // patient: Patient;

  // @ManyToOne(() => Location)
  // @JoinColumn({ name: 'location_id' })
  // location: Location;
}