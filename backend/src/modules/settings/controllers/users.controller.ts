import { Controller, Get, Post, Body, Patch, Param, Delete, UseGuards, Query } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth } from '@nestjs/swagger';
import { JwtAuthGuard } from '../../auth/jwt-auth.guard';
import { UsersService } from '../services/users.service';
import { User } from '../entities/user.entity';

@ApiTags('Settings - Users')
@Controller('settings/users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Post()
  @ApiOperation({ summary: 'Create a new user' })
  @ApiResponse({ status: 201, type: User })
  create(@Body() createUserDto: Partial<User>): Promise<User> {
    return this.usersService.create(createUserDto);
  }

  @Get()
  @ApiOperation({ summary: 'Get all users' })
  @ApiResponse({ status: 200, type: [User] })
  findAll(
    @Query('locationId') locationId?: string,
    @Query('page') page?: string,
    @Query('limit') limit?: string,
    @Query('departmentId') departmentId?: string
  ) {
    const locationIdNum = locationId ? parseInt(locationId) : undefined;
    const pageNum = page ? parseInt(page) : 1;
    const limitNum = limit ? parseInt(limit) : 10;
    const departmentIdNum = departmentId ? parseInt(departmentId) : undefined;
    return this.usersService.findAll(locationIdNum, pageNum, limitNum, departmentIdNum);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get user by ID' })
  @ApiResponse({ status: 200, type: User })
  findOne(@Param('id') id: string): Promise<User> {
    return this.usersService.findOne(+id);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update user' })
  @ApiResponse({ status: 200, type: User })
  update(@Param('id') id: string, @Body() updateUserDto: Partial<User>): Promise<User> {
    return this.usersService.update(+id, updateUserDto);
  }

  @Patch(':id/toggle-status')
  @ApiOperation({ summary: 'Toggle user active status' })
  @ApiResponse({ status: 200, type: User })
  toggleStatus(@Param('id') id: string): Promise<User> {
    return this.usersService.toggleStatus(+id);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete user' })
  remove(@Param('id') id: string): Promise<void> {
    return this.usersService.remove(+id);
  }

  @Get(':id/mobile-numbers')
  @ApiOperation({ summary: 'Get mobile numbers assigned to user' })
  @ApiResponse({ status: 200 })
  getMobileNumbers(@Param('id') id: string) {
    return this.usersService.getMobileNumbers(+id);
  }

  @Get('test/mobile-numbers/:id')
  @ApiOperation({ summary: 'Test mobile numbers endpoint (no auth)' })
  testMobileNumbers(@Param('id') id: string) {
    return this.usersService.getMobileNumbers(+id);
  }

  @Get('debug/mobile-numbers')
  @ApiOperation({ summary: 'Debug - show all mobile numbers' })
  debugMobileNumbers() {
    return this.usersService.debugMobileNumbers();
  }

  @Get('mobile-test/:id')
  @ApiOperation({ summary: 'Test mobile numbers without auth' })
  async mobileTest(@Param('id') id: string) {
    return this.usersService.getMobileNumbers(+id);
  }

  @Post('save-call-record')
  @ApiOperation({ summary: 'Save call record' })
  async saveCallRecord(@Body() callData: any) {
    return this.usersService.saveCallRecord(callData);
  }
}