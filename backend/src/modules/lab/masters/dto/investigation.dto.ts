import { IsString, IsBoolean, IsOptional } from 'class-validator';

export class CreateInvestigationDto {
  @IsString()
  code: string;

  @IsString()
  description: string;

  @IsString()
  @IsOptional()
  method?: string;

  @IsOptional()
  unitId?: number;

  @IsString()
  @IsOptional()
  resultType?: string;

  @IsString()
  @IsOptional()
  defaultValue?: string;

  @IsOptional()
  locationId?: number;

  @IsBoolean()
  @IsOptional()
  isActive?: boolean = true;
}

export class UpdateInvestigationDto {
  @IsString()
  @IsOptional()
  code?: string;

  @IsString()
  @IsOptional()
  description?: string;

  @IsString()
  @IsOptional()
  method?: string;

  @IsOptional()
  unitId?: number;

  @IsString()
  @IsOptional()
  resultType?: string;

  @IsString()
  @IsOptional()
  defaultValue?: string;

  @IsOptional()
  locationId?: number;

  @IsBoolean()
  @IsOptional()
  isActive?: boolean;
}