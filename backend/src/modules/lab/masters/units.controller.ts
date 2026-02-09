import { Controller, Get, Post, Patch, Delete, Body, Param, Query, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../../auth/jwt-auth.guard';
import { UnitsService } from './units.service';
import { CreateUnitDto, UpdateUnitDto } from './dto/unit.dto';

@Controller('lab/masters/units')
@UseGuards(JwtAuthGuard)
export class UnitsController {
  constructor(private readonly unitsService: UnitsService) {}

  @Get()
  async findAll(@Query('locationId') locationId?: string) {
    return this.unitsService.findAll(locationId ? parseInt(locationId) : undefined);
  }

  @Post()
  async create(@Body() createUnitDto: CreateUnitDto) {
    return this.unitsService.create(createUnitDto);
  }

  @Patch(':id')
  async update(@Param('id') id: string, @Body() updateUnitDto: UpdateUnitDto) {
    return this.unitsService.update(parseInt(id), updateUnitDto);
  }

  @Delete(':id')
  async remove(@Param('id') id: string) {
    return this.unitsService.remove(parseInt(id));
  }
}