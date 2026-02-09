import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UsersController } from './controllers/users.controller';
import { RolesController } from './controllers/roles.controller';
import { PermissionsController } from './controllers/permissions.controller';
import { ModulesController } from './controllers/modules.controller';
import { DepartmentsController } from './controllers/departments.controller';
import { LocationsController } from './controllers/locations.controller';
import { UsersService } from './services/users.service';
import { RolesService } from './services/roles.service';
import { PermissionsService } from './services/permissions.service';
import { ModulesService } from './services/modules.service';
import { DepartmentsService } from './services/departments.service';
import { LocationsService } from './services/locations.service';
import { User } from './entities/user.entity';
import { UserInfo } from './entities/user-info.entity';
import { Role } from './entities/role.entity';
import { Module as ModuleEntity } from './entities/module.entity';
import { SubModule } from './entities/sub-module.entity';
import { UserAccess } from './entities/user-access.entity';
import { Department } from './entities/department.entity';
import { Location } from './entities/location.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      User,
      UserInfo,
      Role,
      ModuleEntity,
      SubModule,
      UserAccess,
      Department,
      Location,
    ]),
  ],
  controllers: [
    UsersController,
    RolesController,
    PermissionsController,
    ModulesController,
    DepartmentsController,
    LocationsController,
  ],
  providers: [
    UsersService,
    RolesService,
    PermissionsService,
    ModulesService,
    DepartmentsService,
    LocationsService,
  ],
  exports: [
    UsersService,
    RolesService,
    PermissionsService,
    ModulesService,
    DepartmentsService,
    LocationsService,
  ],
})
export class SettingsModule {}