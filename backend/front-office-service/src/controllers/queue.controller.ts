import { Controller, Get, Post, Body, Param, Query, Put, UseGuards } from '@nestjs/common';
import { QueueService } from '../services/queue.service';
import { CreateQueueTokenDto } from '../dto/create-queue-token.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@Controller('api/queue')
// @UseGuards(JwtAuthGuard) // Temporarily disabled
export class QueueController {
  constructor(private readonly queueService: QueueService) {}

  @Post('tokens')
  createToken(@Body() createQueueTokenDto: CreateQueueTokenDto) {
    return this.queueService.createToken(createQueueTokenDto);
  }

  @Get('tokens')
  findAll(
    @Query('locationId') locationId: number,
    @Query('status') status?: string,
  ) {
    return this.queueService.findAll(locationId, status);
  }

  @Get('tokens/:id')
  findOne(@Param('id') id: number) {
    return this.queueService.findOne(id);
  }

  @Post('call-next')
  callNext(
    @Body('locationId') locationId: number,
    @Body('department') department?: string,
  ) {
    return this.queueService.callNext(locationId, department);
  }

  @Put('tokens/:id/status')
  updateStatus(
    @Param('id') id: number,
    @Body('status') status: string,
  ) {
    return this.queueService.updateStatus(id, status);
  }

  @Get('stats')
  getStats(@Query('locationId') locationId: number) {
    return this.queueService.getQueueStats(locationId);
  }
}