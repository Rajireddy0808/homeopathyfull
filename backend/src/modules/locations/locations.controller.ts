import { Controller, Get, Post, Body, Param, Patch, UseGuards, Request } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { LocationsService } from './locations.service';
import { Location } from './entities/location.entity';

@ApiTags('Locations')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('locations')
export class LocationsController {
  constructor(private readonly locationsService: LocationsService) {}

  @Get()
  @ApiOperation({ summary: 'Get all locations' })
  findAll() {
    return this.locationsService.findAll();
  }

  @Get('user-branches')
  @ApiOperation({ summary: 'Get user accessible branches' })
  async getUserBranches(@Request() req) {
    try {
      console.log('User object:', req.user);
      const locationIdString = req.user?.location_id;
      console.log('User location ID string:', locationIdString);
      
      let userLocationIds: number[] = [];
      if (locationIdString) {
        userLocationIds = locationIdString.split(',').map(id => parseInt(id.trim())).filter(id => !isNaN(id));
      }
      console.log('Parsed location IDs:', userLocationIds);
      
      const result = await this.locationsService.findByUserLocations(userLocationIds);
      console.log('Locations result:', result);
      return result;
    } catch (error) {
      console.error('Error in getUserBranches:', error);
      throw error;
    }
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get location by ID' })
  findOne(@Param('id') id: string) {
    return this.locationsService.findOne(id);
  }

  @Post()
  @ApiOperation({ summary: 'Create location' })
  create(@Body() createLocationDto: Partial<Location>) {
    return this.locationsService.create(createLocationDto);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update location' })
  update(@Param('id') id: string, @Body() updateLocationDto: Partial<Location>) {
    return this.locationsService.update(parseInt(id), updateLocationDto);
  }
}