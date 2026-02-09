import { Controller, Get, Post, Patch, Delete, Body, Param, Query, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../../auth/jwt-auth.guard';
import { InvestigationsService } from './investigations.service';
import { CreateInvestigationDto, UpdateInvestigationDto } from './dto/investigation.dto';

@Controller('lab/masters/investigations')
@UseGuards(JwtAuthGuard)
export class InvestigationsController {
  constructor(private readonly investigationsService: InvestigationsService) {}

  @Get()
  async findAll(@Query('locationId') locationId?: string) {
    return this.investigationsService.findAll(locationId ? parseInt(locationId) : undefined);
  }

  @Post()
  async create(@Body() createInvestigationDto: CreateInvestigationDto) {
    return this.investigationsService.create(createInvestigationDto);
  }

  @Patch(':id')
  async update(@Param('id') id: string, @Body() updateInvestigationDto: UpdateInvestigationDto) {
    return this.investigationsService.update(parseInt(id), updateInvestigationDto);
  }

  @Delete(':id')
  async remove(@Param('id') id: string) {
    return this.investigationsService.remove(parseInt(id));
  }
}