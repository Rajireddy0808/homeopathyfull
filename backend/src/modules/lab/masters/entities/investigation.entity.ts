import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';

@Entity({ name: 'lab_investigations', schema: 'public' })
export class Investigation {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'varchar', length: 50 })
  code: string;

  @Column({ type: 'varchar', length: 255 })
  description: string;

  @Column({ type: 'varchar', length: 255, nullable: true })
  method: string;

  @Column({ name: 'unit_id', type: 'int', nullable: true })
  unitId: number;

  @Column({ name: 'result_type', type: 'varchar', length: 50, nullable: true })
  resultType: string;

  @Column({ name: 'default_value', type: 'text', nullable: true })
  defaultValue: string;

  @Column({ name: 'location_id', type: 'int', nullable: true })
  locationId: number;

  // Virtual property to get unit description
  unitDescription?: string;

  @Column({ type: 'varchar', length: 1, default: '1' })
  status: string;

  @Column({ name: 'created_at', type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  createdAt: Date;

  @Column({ name: 'updated_at', type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  updatedAt: Date;

  get isActive(): boolean {
    return this.status === '1';
  }
}