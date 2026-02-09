import { Controller, Get, Param } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';

@ApiTags('Mobile Numbers')
@Controller('mobile-numbers')
export class MobileNumbersController {
  
  @Get(':userId')
  @ApiOperation({ summary: 'Get mobile numbers assigned to user' })
  async getMobileNumbers(@Param('userId') userId: string) {
    // Mock data for now - replace with actual database query
    const mockNumbers = [
      {
        id: 789,
        mobile_number: '(555) 987-6543',
        user_id: parseInt(userId),
        last_call_status: 'No Answer',
        assigned_date: '2024-12-01'
      },
      {
        id: 654,
        mobile_number: '(555) 555-7890',
        user_id: parseInt(userId),
        last_call_status: 'Answered',
        assigned_date: '2024-12-02'
      },
      {
        id: 321,
        mobile_number: '(555) 321-4567',
        user_id: parseInt(userId),
        last_call_status: 'Voicemail',
        assigned_date: '2024-12-03'
      }
    ];
    
    return mockNumbers;
  }
}