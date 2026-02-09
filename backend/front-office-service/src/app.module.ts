import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';

import { getDatabaseConfig } from './config/database.config';

// Entities
import { Location } from './entities/location.entity';
import { Patient } from './entities/patient.entity';
import { PatientQueue } from './entities/patient-queue.entity';
import { PatientTransfer } from './entities/patient-transfer.entity';
import { PatientSupportTicket } from './entities/patient-support-ticket.entity';
import { Gender } from './entities/gender.entity';
import { BloodGroup } from './entities/blood-group.entity';
import { MaritalStatus } from './entities/marital-status.entity';
import { ConsultationType } from './entities/consultation-type.entity';
import { VisitType } from './entities/visit-type.entity';
import { PatientCategory } from './entities/patient-category.entity';
import { PatientPrescription } from './entities/patient-prescription.entity';

// Services
import { MicroserviceClientService } from './services/microservice-client.service';
import { PatientService } from './services/patient.service';
import { QueueService } from './services/queue.service';
import { GenderService } from './services/gender.service';
import { BloodGroupService } from './services/blood-group.service';
import { MaritalStatusService } from './services/marital-status.service';
import { ConsultationTypeService } from './services/consultation-type.service';
import { VisitTypeService } from './services/visit-type.service';
import { PatientCategoryService } from './services/patient-category.service';
import { PatientPrescriptionService } from './services/patient-prescription.service';

// Controllers
import { PatientController } from './controllers/patient.controller';
import { QueueController } from './controllers/queue.controller';
import { FrontOfficeController } from './controllers/front-office.controller';
import { GenderController } from './controllers/gender.controller';
import { BloodGroupController } from './controllers/blood-group.controller';
import { MaritalStatusController } from './controllers/marital-status.controller';
import { ConsultationTypeController } from './controllers/consultation-type.controller';
import { VisitTypeController } from './controllers/visit-type.controller';
import { PatientCategoryController } from './controllers/patient-category.controller';
import { PatientPrescriptionController } from './controllers/patient-prescription.controller';

// Auth
import { JwtStrategy } from './auth/jwt.strategy';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: getDatabaseConfig,
      inject: [ConfigService],
    }),

    TypeOrmModule.forFeature([
      Location,
      Patient,
      PatientQueue,
      PatientTransfer,
      PatientSupportTicket,
      Gender,
      BloodGroup,
      MaritalStatus,
      ConsultationType,
      VisitType,
      PatientCategory,
      PatientPrescription,
    ]),

    PassportModule,
    JwtModule.register({
      secret: '3I3zCSdmG2Qt8X0lHvKkC5fsQp8Wfpx9MFdECFs9CS9Cu97GMrrpdptIxsP8sYPr',
      signOptions: { expiresIn: '24h' },
    }),
  ],
  controllers: [
    PatientController,
    QueueController,
    FrontOfficeController,
    GenderController,
    BloodGroupController,
    MaritalStatusController,
    ConsultationTypeController,
    VisitTypeController,
    PatientCategoryController,
    PatientPrescriptionController,
  ],
  providers: [
    MicroserviceClientService,
    PatientService,
    QueueService,
    GenderService,
    BloodGroupService,
    MaritalStatusService,
    ConsultationTypeService,
    VisitTypeService,
    PatientCategoryService,
    PatientPrescriptionService,
    JwtStrategy,
  ],
})
export class AppModule {}