import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, ManyToOne, JoinColumn, OneToMany } from 'typeorm';
import { Location } from './location.entity';
import { EstimateItem } from './estimate-item.entity';

@Entity('estimates')
export class Estimate {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ name: 'estimate_number', length: 20 })
  estimateNumber: string;

  @Column({ name: 'location_id' })
  locationId: number;

  @Column({ name: 'patient_id', nullable: true })
  patientId: number;

  @Column({ name: 'patient_name', length: 100, nullable: true })
  patientName: string;

  @Column({ name: 'patient_phone', length: 15, nullable: true })
  patientPhone: string;

  @Column({ name: 'total_amount', type: 'decimal', precision: 10, scale: 2 })
  totalAmount: number;

  @Column({ name: 'discount_amount', type: 'decimal', precision: 10, scale: 2, default: 0 })
  discountAmount: number;

  @Column({ name: 'net_amount', type: 'decimal', precision: 10, scale: 2 })
  netAmount: number;

  @Column({ name: 'valid_until', type: 'date', nullable: true })
  validUntil: Date;

  @Column({ 
    default: 'draft',
    enum: ['draft', 'sent', 'accepted', 'rejected', 'expired']
  })
  status: string;

  @Column({ name: 'created_by' })
  createdBy: number;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;

  @ManyToOne(() => Location)
  @JoinColumn({ name: 'location_id' })
  location: Location;

  @OneToMany(() => EstimateItem, estimateItem => estimateItem.estimate)
  items: EstimateItem[];
}