import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { DatabaseConfig } from './config/database.config';
import { AuthModule } from './modules/auth/auth.module';
import { LocationsModule } from './modules/locations/locations.module';
import { PatientsModule } from './modules/patients/patients.module';
import { AppointmentsModule } from './modules/appointments/appointments.module';
import { BillingModule } from './modules/billing/billing.module';
import { PharmacyModule } from './modules/pharmacy/pharmacy.module';
import { LabModule } from './modules/lab/lab.module';
import { InpatientModule } from './modules/inpatient/inpatient.module';
import { InsuranceModule } from './modules/insurance/insurance.module';
import { MaterialManagementModule } from './modules/material-management/material-management.module';
import { DoctorsModule } from './modules/doctors/doctors.module';
import { FrontOfficeModule } from './modules/front-office/front-office.module';
import { TelecallerModule } from './modules/telecaller/telecaller.module';
import { ReportsModule } from './modules/reports/reports.module';
import { SettingsModule } from './modules/settings/settings.module';


@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    TypeOrmModule.forRootAsync({
      useClass: DatabaseConfig,
    }),
    AuthModule,
    LocationsModule,
    PatientsModule,
    AppointmentsModule,
    BillingModule,
    PharmacyModule,
    LabModule,
    InpatientModule,
    InsuranceModule,
    MaterialManagementModule,
    DoctorsModule,
    FrontOfficeModule,
    TelecallerModule,
    ReportsModule,
    SettingsModule,

  ],
})
export class AppModule {}