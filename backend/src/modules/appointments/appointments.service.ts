import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Appointment } from './entities/appointment.entity';

@Injectable()
export class AppointmentsService {
  constructor(
    @InjectRepository(Appointment)
    private appointmentRepository: Repository<Appointment>,
  ) {}

  async create(appointmentData: Partial<Appointment>): Promise<Appointment> {
    const appointmentNumber = await this.generateAppointmentNumber(appointmentData.locationId);
    const appointment = this.appointmentRepository.create({
      ...appointmentData,
      appointmentNumber,
    });
    return this.appointmentRepository.save(appointment);
  }

  async findAll(locationId: string): Promise<Appointment[]> {
    return this.appointmentRepository.find({
      where: { locationId: parseInt(locationId) },
      relations: ['patient', 'doctor'],
    });
  }

  async findOne(id: string): Promise<Appointment> {
    return this.appointmentRepository.findOne({
      where: { id: parseInt(id) },
      relations: ['patient', 'doctor'],
    });
  }

  async update(id: string, updateData: Partial<Appointment>): Promise<Appointment> {
    await this.appointmentRepository.update(parseInt(id), updateData);
    return this.findOne(id);
  }

  private async generateAppointmentNumber(locationId: number): Promise<string> {
    const count = await this.appointmentRepository.count({ where: { locationId } });
    return `APT${(count + 1).toString().padStart(6, '0')}`;
  }
}