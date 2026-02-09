import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity('patient_transfers')
export class PatientTransfer {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ name: 'transfer_number', length: 20 })
  transferNumber: string;

  @Column({ name: 'patient_id' })
  patientId: number;

  @Column({ name: 'from_location_id' })
  fromLocationId: number;

  @Column({ name: 'to_location_id' })
  toLocationId: number;

  @Column({ name: 'from_bed_id', nullable: true })
  fromBedId: number;

  @Column({ name: 'to_bed_id', nullable: true })
  toBedId: number;

  @Column({ name: 'transfer_date' })
  transferDate: Date;

  @Column('text', { nullable: true })
  reason: string;

  @Column({ 
    default: 'pending',
    enum: ['pending', 'in_transit', 'completed', 'cancelled']
  })
  status: string;

  @Column({ name: 'transferred_by' })
  transferredBy: number;

  @Column({ name: 'received_by', nullable: true })
  receivedBy: number;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  // Foreign key relationships removed - managed by respective services
  // @ManyToOne(() => Patient)
  // @JoinColumn({ name: 'patient_id' })
  // patient: Patient;

  // @ManyToOne(() => Location)
  // @JoinColumn({ name: 'from_location_id' })
  // fromLocation: Location;

  // @ManyToOne(() => Location)
  // @JoinColumn({ name: 'to_location_id' })
  // toLocation: Location;
}