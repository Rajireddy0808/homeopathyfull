import { IsNotEmpty, IsOptional, IsNumber, IsString } from 'class-validator';

export class CreateQueueTokenDto {
  @IsNotEmpty()
  @IsNumber()
  patientId: number;

  @IsOptional()
  @IsNumber()
  appointmentId?: number;

  @IsOptional()
  @IsString()
  department?: string;

  @IsOptional()
  @IsNumber()
  priorityLevel?: number;

  @IsNotEmpty()
  @IsNumber()
  locationId: number;
}