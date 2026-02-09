import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity('hims_users_setting')
export class User {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  username: string;

  @Column()
  email: string;

  @Column()
  password: string;

  @Column({ name: 'first_name' })
  firstName: string;

  @Column({ name: 'last_name' })
  lastName: string;

  @Column({ name: 'location_ids' })
  locationIds: string;

  @Column()
  active: boolean;

  @Column()
  phone: string;

  @Column()
  specialization: string;

  @Column({ name: 'employee_id' })
  employeeId: string;

  @Column({ name: 'role_id' })
  roleId: number;

  @Column({ name: 'location_id' })
  locationId: number;
}