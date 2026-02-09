import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { LabMastersModule } from './masters/lab-masters.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([]),
    LabMastersModule,
  ],
})
export class LabModule {}