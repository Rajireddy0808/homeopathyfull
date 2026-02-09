import { Controller, Post, Get, Body, UseGuards, Request, UseInterceptors, UploadedFile, Query, Param } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { MobileNumbersService } from '../services/mobile-numbers.service';

@ApiTags('Mobile Numbers')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('mobile-numbers')
export class MobileNumbersController {
  constructor(private readonly mobileNumbersService: MobileNumbersService) {}

  @Get('today-calls')
  @ApiOperation({ summary: 'Get today calls for logged-in user' })
  async getTodayCalls(
    @Request() req,
    @Query('page') page: number = 1,
    @Query('limit') limit: number = 10,
    @Query('location_id') locationId?: number
  ) {
    const userId = req.user?.user_id || req.user?.id || req.user?.sub;
    return this.mobileNumbersService.getTodayCallsByUserId(userId, page, limit, locationId);
  }

  @Get('my-numbers')
  @ApiOperation({ summary: 'Get mobile numbers for logged-in user' })
  async getMyMobileNumbers(
    @Request() req,
    @Query('page') page: number = 1,
    @Query('limit') limit: number = 10,
    @Query('location_id') locationId?: number,
    @Query('from_date') fromDate?: string,
    @Query('to_date') toDate?: string
  ) {
    const userId = req.user?.user_id || req.user?.id || req.user?.sub;
    console.log('Getting mobile numbers for logged-in user:', userId);
    return this.mobileNumbersService.getMobileNumbersByUserId(userId, page, limit, locationId, fromDate, toDate);
  }

  @Get('user/:userId')
  @ApiOperation({ summary: 'Get mobile numbers for specific user (mobile app)' })
  async getMobileNumbersByUser(
    @Param('userId') userId: number,
    @Query('page') page: number = 1,
    @Query('limit') limit: number = 10,
    @Query('location_id') locationId?: number,
    @Query('from_date') fromDate?: string,
    @Query('to_date') toDate?: string
  ) {
    console.log('Getting mobile numbers for user:', userId);
    return this.mobileNumbersService.getMobileNumbersByUserId(userId, page, limit, locationId, fromDate, toDate);
  }

  @Get()
  @ApiOperation({ summary: 'Get all mobile numbers' })
  async getAllMobileNumbers(@Request() req) {
    const userId = req.user?.user_id || req.user?.id || req.user?.sub;
    console.log('Getting mobile numbers for user:', userId);
    return this.mobileNumbersService.getAllMobileNumbers(userId);
  }

  @Post('bulk-upload')
  @ApiOperation({ summary: 'Bulk upload mobile numbers from Excel' })
  @UseInterceptors(FileInterceptor('file'))
  async bulkUpload(@UploadedFile() file: any, @Request() req) {
    const userId = req.user?.user_id || req.user?.id;
    const locationId = req.user?.location_id || 1;
    return this.mobileNumbersService.bulkUpload(file, userId, locationId);
  }

  @Post()
  @ApiOperation({ summary: 'Add single mobile number' })
  async addMobileNumber(@Body() data: { mobile: string }, @Request() req) {
    const userId = req.user?.user_id || req.user?.id;
    const locationId = req.user?.location_id || 1;
    return this.mobileNumbersService.addMobileNumber(data.mobile, userId, locationId);
  }
}