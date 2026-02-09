import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';

@Entity({ name: 'units', schema: 'public' })
export class Unit {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'varchar', length: 50 })
  code: string;

  @Column({ type: 'varchar', length: 255 })
  description: string;

  @Column({ type: 'varchar', length: 1, default: '1' })
  status: string;

  @Column({ name: 'location_id', type: 'int', nullable: true })
  locationId: number;

  @Column({ name: 'created_at', type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  createdAt: Date;

  @Column({ name: 'updated_at', type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  updatedAt: Date;

  get isActive(): boolean {
    return this.status === '1';
  }
}