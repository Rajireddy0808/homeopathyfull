import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { MobileNumbersController } from './mobile-numbers.controller';

@Module({
  imports: [TypeOrmModule.forFeature([])],
  controllers: [MobileNumbersController],
})
export class TelecallerModule {}