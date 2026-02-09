import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, In } from 'typeorm';
import { Department } from '../entities/department.entity';

@Injectable()
export class DepartmentsService {
  constructor(
    @InjectRepository(Department)
    private departmentRepository: Repository<Department>,
  ) {}

  async findAll(): Promise<Department[]> {
    return this.departmentRepository.find({ 
      where: { isActive: true },
      order: { name: 'ASC' } 
    });
  }

  async findOne(id: number): Promise<Department> {
    const department = await this.departmentRepository.findOne({ where: { id } });
    if (!department) {
      throw new NotFoundException(`Department with ID ${id} not found`);
    }
    return department;
  }

  async create(departmentData: Partial<Department>): Promise<Department> {
    const department = this.departmentRepository.create(departmentData);
    return this.departmentRepository.save(department);
  }

  async update(id: number, departmentData: Partial<Department>): Promise<Department> {
    await this.departmentRepository.update(id, departmentData);
    return this.findOne(id);
  }

  async findByLocationId(locationId: number): Promise<any[]> {
    try {
      console.log('Departments Service - locationId:', locationId);
      
      // Debug: Check table structures
      const ulpData = await this.departmentRepository.query(
        'SELECT * FROM user_location_permissions WHERE location_id = $1',
        [locationId]
      );
      console.log('Debug - user_location_permissions data:', ulpData);
      
      const userData = await this.departmentRepository.query(
        'SELECT id, first_name, last_name, is_active FROM users WHERE is_active = true'
      );
      console.log('Debug - users data:', userData);
      
      const result = await this.departmentRepository
        .createQueryBuilder('dept')
        .leftJoin('user_location_permissions', 'ulp', 'ulp.department_id = dept.id AND ulp.location_id = :locationId')
        .leftJoin('users', 'u', 'u.id = ulp.user_id AND u.is_active = true')
        .select([
          'dept.id as id',
          'dept.name as name', 
          'dept.description as description',
          'dept.head_of_department as "headOfDepartment"',
          'dept.location_id as "locationId"',
          'dept.is_active as "isActive"',
          'COUNT(DISTINCT u.id) as "staffCount"'
        ])
        .where('dept.location_id = :locationId', { locationId })
        .andWhere('dept.is_active = true')
        .groupBy('dept.id, dept.name, dept.description, dept.head_of_department, dept.location_id, dept.is_active')
        .orderBy('dept.name', 'ASC')
        .getRawMany();
        
      console.log('Departments Service - departments with staff count:', result);
      return result;
    } catch (error) {
      console.error('Departments Service error:', error);
      throw error;
    }
  }

  async remove(id: number): Promise<void> {
    const result = await this.departmentRepository.delete(id);
    if (result.affected === 0) {
      throw new NotFoundException(`Department with ID ${id} not found`);
    }
  }
}