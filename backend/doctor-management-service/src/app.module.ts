import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { DatabaseConfig } from './config/database.config';
import { DoctorsController } from './controllers/doctors.controller';
import { DoctorsService } from './services/doctors.service';
import { DoctorTimeslot } from './entities/doctor-timeslot.entity';
import { User } from './entities/user.entity';
import { DoctorConsultationFee } from './entities/doctor-consultation-fee.entity';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    TypeOrmModule.forRootAsync({
      useClass: DatabaseConfig,
    }),
    TypeOrmModule.forFeature([DoctorTimeslot, User, DoctorConsultationFee]),
  ],
  controllers: [DoctorsController],
  providers: [DoctorsService],
})
export class AppModule {}