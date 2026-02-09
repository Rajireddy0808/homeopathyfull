import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UnitsController } from './units.controller';
import { UnitsService } from './units.service';
import { InvestigationsController } from './investigations.controller';
import { InvestigationsService } from './investigations.service';
import { Unit } from './entities/unit.entity';
import { Investigation } from './entities/investigation.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Unit, Investigation])],
  controllers: [UnitsController, InvestigationsController],
  providers: [UnitsService, InvestigationsService],
  exports: [UnitsService, InvestigationsService],
})
export class LabMastersModule {}