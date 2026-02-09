import { Controller, Post, Get, Delete, Body, Param, UseGuards, Request } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

// In-memory storage for call requests
let callRequests = [];
let requestIdCounter = 1;

@Controller()
export class MobileCallController {
  
  @Post('trigger-mobile-call')
  triggerMobileCall(@Body() body: { phone_number: string; patient_name?: string; patient_id?: number; requested_by?: string }) {
    const { phone_number, patient_name, patient_id, requested_by } = body;
    
    const callRequest = {
      id: requestIdCounter++,
      phone_number,
      patient_name: patient_name || 'Unknown Patient',
      patient_id,
      requested_by: requested_by || 'System',
      created_at: new Date().toISOString(),
    };
    
    callRequests.push(callRequest);
    console.log('New call request created:', callRequest);
    
    return { success: true, message: 'Mobile call request created', data: callRequest };
  }

  @Get('mobile-call-requests')
  getMobileCallRequests() {
    console.log('Getting all call requests:', callRequests);
    return callRequests;
  }

  @Delete('mobile-call-requests/:id')
  deleteCallRequest(@Param('id') id: string) {
    const requestId = parseInt(id);
    const initialLength = callRequests.length;
    callRequests = callRequests.filter(request => request.id !== requestId);
    const deleted = callRequests.length < initialLength;
    console.log(`Delete request ${requestId}: ${deleted ? 'success' : 'not found'}`);
    return { success: deleted };
  }
}