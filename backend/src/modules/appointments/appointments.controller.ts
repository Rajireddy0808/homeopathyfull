import { Controller, Get, Post, Body, Patch, Param, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiHeader } from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { AppointmentsService } from './appointments.service';
import { Appointment } from './entities/appointment.entity';
import { CurrentLocation } from '../../common/decorators/location.decorator';

@ApiTags('Appointments')
@ApiBearerAuth()
@ApiHeader({ name: 'x-location-id', description: 'Location ID', required: true })
@UseGuards(JwtAuthGuard)
@Controller('appointments')
export class AppointmentsController {
  constructor(private readonly appointmentsService: AppointmentsService) {}

  @Post()
  @ApiOperation({ summary: 'Create appointment' })
  create(@Body() createAppointmentDto: Partial<Appointment>) {
    return this.appointmentsService.create(createAppointmentDto);
  }

  @Get()
  @ApiOperation({ summary: 'Get all appointments' })
  findAll(@CurrentLocation() locationId: string) {
    return this.appointmentsService.findAll(locationId);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get appointment by ID' })
  findOne(@Param('id') id: string) {
    return this.appointmentsService.findOne(id);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update appointment' })
  update(@Param('id') id: string, @Body() updateAppointmentDto: Partial<Appointment>) {
    return this.appointmentsService.update(id, updateAppointmentDto);
  }
}