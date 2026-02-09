import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Location } from '../entities/location.entity';

@Injectable()
export class LocationsService {
  constructor(
    @InjectRepository(Location)
    private locationRepository: Repository<Location>,
  ) {}

  async findAll(): Promise<Location[]> {
    const locations = await this.locationRepository.find({ 
      order: { name: 'ASC' } 
    });
    console.log('All locations found:', locations.length);
    console.log('Locations:', locations);
    return locations;
  }
}