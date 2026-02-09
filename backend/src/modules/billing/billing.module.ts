import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Bill, BillItem } from './entities/bill.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Bill, BillItem])],
})
export class BillingModule {}