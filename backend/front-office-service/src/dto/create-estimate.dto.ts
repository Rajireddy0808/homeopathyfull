import { IsNotEmpty, IsOptional, IsNumber, IsString, IsArray, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';

export class CreateEstimateItemDto {
  @IsNotEmpty()
  @IsString()
  itemName: string;

  @IsOptional()
  @IsString()
  itemCode?: string;

  @IsNotEmpty()
  @IsNumber()
  quantity: number;

  @IsNotEmpty()
  @IsNumber()
  unitPrice: number;

  @IsOptional()
  @IsString()
  category?: string;
}

export class CreateEstimateDto {
  @IsNotEmpty()
  @IsNumber()
  locationId: number;

  @IsOptional()
  @IsNumber()
  patientId?: number;

  @IsOptional()
  @IsString()
  patientName?: string;

  @IsOptional()
  @IsString()
  patientPhone?: string;

  @IsOptional()
  @IsNumber()
  discountAmount?: number;

  @IsOptional()
  @IsString()
  validUntil?: string;

  @IsNotEmpty()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => CreateEstimateItemDto)
  items: CreateEstimateItemDto[];

  @IsNotEmpty()
  @IsNumber()
  createdBy: number;
}