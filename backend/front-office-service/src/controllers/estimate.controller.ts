import { Controller, Get, Post, Body, Param, Query, Put, UseGuards } from '@nestjs/common';
import { EstimateService } from '../services/estimate.service';
import { CreateEstimateDto } from '../dto/create-estimate.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@Controller('api/estimates')
@UseGuards(JwtAuthGuard)
export class EstimateController {
  constructor(private readonly estimateService: EstimateService) {}

  @Post()
  create(@Body() createEstimateDto: CreateEstimateDto) {
    return this.estimateService.create(createEstimateDto);
  }

  @Get()
  findAll(@Query('locationId') locationId: number) {
    return this.estimateService.findAll(locationId);
  }

  @Get(':id')
  findOne(@Param('id') id: number) {
    return this.estimateService.findOne(id);
  }

  @Put(':id/status')
  updateStatus(
    @Param('id') id: number,
    @Body('status') status: string,
  ) {
    return this.estimateService.updateStatus(id, status);
  }

  @Post(':id/convert-to-bill')
  convertToBill(
    @Param('id') id: number,
    @Body('userId') userId: number,
  ) {
    return this.estimateService.convertToBill(id, userId);
  }
}