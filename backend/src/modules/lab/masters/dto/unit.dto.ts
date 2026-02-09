import { IsString, IsBoolean, IsOptional } from 'class-validator';

export class CreateUnitDto {
  @IsString()
  code: string;

  @IsString()
  description: string;

  @IsBoolean()
  @IsOptional()
  isActive?: boolean = true;

  @IsOptional()
  locationId?: number;
}

export class UpdateUnitDto {
  @IsString()
  @IsOptional()
  code?: string;

  @IsString()
  @IsOptional()
  description?: string;

  @IsBoolean()
  @IsOptional()
  isActive?: boolean;

  @IsOptional()
  locationId?: number;
}