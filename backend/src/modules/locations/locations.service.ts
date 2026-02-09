import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, In } from 'typeorm';
import { Location } from './entities/location.entity';

@Injectable()
export class LocationsService {
  constructor(
    @InjectRepository(Location)
    private locationRepository: Repository<Location>,
  ) {}

  async findAll(): Promise<Location[]> {
    return this.locationRepository.find({ order: { name: 'ASC' } });
  }

  async findByUserLocations(userLocationIds: number[]): Promise<Location[]> {
    try {
      console.log('Service - userLocationIds:', userLocationIds);
      
      // If no location IDs (admin users), return all locations
      if (!userLocationIds || userLocationIds.length === 0) {
        const result = await this.locationRepository.find({ 
          where: { isActive: true },
          order: { id: 'ASC' }
        });
        console.log('Service - all locations for admin:', result.length);
        return result;
      }
      
      // Users with specific locations get only their assigned locations
      const result = await this.locationRepository.find({ 
        where: { 
          id: userLocationIds.length === 1 ? userLocationIds[0] : In(userLocationIds),
          isActive: true 
        },
        order: { id: 'ASC' }
      });
      console.log('Service - user specific locations:', result.length);
      return result;
    } catch (error) {
      console.error('Service error:', error);
      throw error;
    }
  }

  async findByUserLocation(userLocationId: number | null): Promise<Location[]> {
    return this.findByUserLocations(userLocationId ? [userLocationId] : []);
  }

  async findOne(id: string): Promise<Location> {
    return this.locationRepository.findOne({ where: { id: parseInt(id) } });
  }

  async create(locationData: Partial<Location>): Promise<Location> {
    const location = this.locationRepository.create(locationData);
    return this.locationRepository.save(location);
  }

  async update(id: number, locationData: Partial<Location>): Promise<Location> {
    await this.locationRepository.update(id, locationData);
    return this.findOne(id.toString());
  }
}