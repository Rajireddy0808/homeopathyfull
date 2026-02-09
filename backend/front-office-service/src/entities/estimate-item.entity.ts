import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn } from 'typeorm';
import { Estimate } from './estimate.entity';

@Entity('estimate_items')
export class EstimateItem {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ name: 'estimate_id' })
  estimateId: number;

  @Column({ name: 'item_name', length: 100 })
  itemName: string;

  @Column({ name: 'item_code', length: 50, nullable: true })
  itemCode: string;

  @Column()
  quantity: number;

  @Column({ name: 'unit_price', type: 'decimal', precision: 10, scale: 2 })
  unitPrice: number;

  @Column({ name: 'total_price', type: 'decimal', precision: 10, scale: 2 })
  totalPrice: number;

  @Column({ length: 50, nullable: true })
  category: string;

  @ManyToOne(() => Estimate, estimate => estimate.items, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'estimate_id' })
  estimate: Estimate;
}