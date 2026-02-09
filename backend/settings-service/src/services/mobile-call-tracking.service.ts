import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { MobileNumber } from '../entities/mobile-number.entity';

@Injectable()
export class MobileCallTrackingService {
  constructor(
    @InjectRepository(MobileNumber)
    private mobileNumberRepository: Repository<MobileNumber>,
  ) {}

  async getAssignedNumbers(userId: number) {
    return this.mobileNumberRepository.find({
      where: { 
        user_id: userId,
        is_active: true 
      },
      order: { id: 'ASC' }
    });
  }

  async updateCallDetails(mobileId: number, callData: any, userId: number) {
    const updateData = {
      next_call_date: callData.nextCallDate ? new Date(callData.nextCallDate) : null,
      disposition: callData.disposition,
      patient_feeling: callData.patientFeeling,
      notes: callData.notes,
      caller_by: userId,
      caller_created_at: new Date(),
      caller_updated_at: new Date()
    };

    await this.mobileNumberRepository.update(mobileId, updateData);

    return {
      success: true,
      message: 'Call details updated successfully'
    };
  }
}