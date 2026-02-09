import { Controller, Get, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth } from '@nestjs/swagger';
import { JwtAuthGuard } from '../../auth/jwt-auth.guard';
import { LocationsService } from '../services/locations.service';
import { Location } from '../entities/location.entity';

@ApiTags('Settings - Locations')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('settings/locations')
export class LocationsController {
  constructor(private readonly locationsService: LocationsService) {}

  @Get()
  @ApiOperation({ summary: 'Get all locations' })
  @ApiResponse({ status: 200, type: [Location] })
  findAll(): Promise<Location[]> {
    return this.locationsService.findAll();
  }
}