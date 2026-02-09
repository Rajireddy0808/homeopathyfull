import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Role } from '../entities/role.entity';
import { UserAccess } from '../entities/user-access.entity';
import { Module } from '../entities/module.entity';
import { User } from '../entities/user.entity';

@Injectable()
export class RolesService {
  constructor(
    @InjectRepository(Role)
    private roleRepository: Repository<Role>,
    @InjectRepository(UserAccess)
    private userAccessRepository: Repository<UserAccess>,
    @InjectRepository(Module)
    private moduleRepository: Repository<Module>,
    @InjectRepository(User)
    private userRepository: Repository<User>,
  ) {}

  async findAll(locationId?: number, includeModules?: boolean): Promise<Role[]> {
    let roles: Role[];
    
    if (!locationId) {
      roles = await this.roleRepository.find({ order: { name: 'ASC' } });
    } else {
      roles = await this.roleRepository.find({
        where: [
          { locationId: null },
          { locationId: locationId }
        ],
        order: { name: 'ASC' }
      });
    }

    // Add user count and modules for each role
    for (const role of roles) {
      // Get user count for this role from user_location_permissions table
      const userCountResult = await this.userRepository.query(
        'SELECT COUNT(DISTINCT user_id) as count FROM user_location_permissions WHERE role_id = $1',
        [role.id]
      );
      (role as any).userCount = parseInt(userCountResult[0]?.count || '0');
      
      if (includeModules) {
        // Add modules for each role (empty array if no user_access entries)
        const userAccess = await this.userAccessRepository.find({
          where: { roleId: role.id }
        });
        
        if (userAccess.length > 0) {
          const moduleIds = [...new Set(userAccess.map(ua => ua.moduleId))];
          const modules = await this.moduleRepository.find({
            where: moduleIds.map(id => ({ id })),
            select: ['name']
          });
          (role as any).modules = modules.map(m => m.name);
        } else {
          (role as any).modules = [];
        }
      }
    }

    return roles;
  }

  async findOne(id: number): Promise<Role> {
    const role = await this.roleRepository.findOne({ where: { id } });
    if (!role) {
      throw new NotFoundException(`Role with ID ${id} not found`);
    }
    return role;
  }

  async create(roleData: Partial<Role>): Promise<Role> {
    try {
      console.log('Creating role with data:', roleData);
      
      // Convert boolean to 0/1
      const createData = { ...roleData };
      if (typeof createData.isActive !== 'undefined') {
        createData.isActive = createData.isActive ? 1 : 0;
      }
      
      const role = this.roleRepository.create(createData);
      const savedRole = await this.roleRepository.save(role);
      console.log('Role created successfully:', savedRole);
      return savedRole;
    } catch (error) {
      console.error('Error creating role:', error);
      throw error;
    }
  }

  async update(id: number, roleData: Partial<Role>): Promise<Role> {
    console.log('Updating role with data:', roleData);
    
    // Convert boolean to 0/1
    const updateData = { ...roleData };
    if (typeof updateData.isActive !== 'undefined') {
      updateData.isActive = updateData.isActive ? 1 : 0;
    }
    
    const result = await this.roleRepository.update(id, updateData);
    console.log('Update result:', result);
    return this.findOne(id);
  }

  async remove(id: number): Promise<void> {
    const result = await this.roleRepository.delete(id);
    if (result.affected === 0) {
      throw new NotFoundException(`Role with ID ${id} not found`);
    }
  }

  async getRolePermissions(roleId: number): Promise<any[]> {
    return this.userAccessRepository.find({
      where: { roleId }
    });
  }

  async updateRolePermissions(roleId: number, permissions: any[]): Promise<void> {
    try {
      console.log('Updating permissions for role:', roleId);
      console.log('Permissions data:', JSON.stringify(permissions, null, 2));
      
      // Delete existing permissions for this role
      await this.userAccessRepository.delete({ roleId });
      
      // Insert new permissions
      if (permissions.length > 0) {
        const userAccessEntries = permissions
          .filter(p => p.add || p.edit || p.delete || p.view) // Only save permissions that have at least one action enabled
          .map(permission => ({
            roleId,
            moduleId: permission.moduleId,
            subModuleId: permission.subModuleId || null,
            add: permission.add ? 1 : 0,
            edit: permission.edit ? 1 : 0,
            delete: permission.delete ? 1 : 0,
            view: permission.view ? 1 : 0
          }));
        
        console.log('User access entries to save:', JSON.stringify(userAccessEntries, null, 2));
        
        if (userAccessEntries.length > 0) {
          await this.userAccessRepository.save(userAccessEntries);
        }
      }
      
      console.log('Permissions updated successfully');
    } catch (error) {
      console.error('Error updating role permissions:', error);
      throw error;
    }
  }
}