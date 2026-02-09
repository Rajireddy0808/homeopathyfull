import { TypeOrmModuleOptions } from '@nestjs/typeorm';
import { ConfigService } from '@nestjs/config';
import { User } from '../entities/user.entity';

export const getUserDatabaseConfig = (configService: ConfigService): TypeOrmModuleOptions => ({
  name: 'userConnection',
  type: 'postgres',
  host: configService.get('DB_HOST'),
  port: configService.get('DB_PORT'),
  username: configService.get('DB_USERNAME'),
  password: configService.get('DB_PASSWORD'),
  database: 'hims_user_settings',
  entities: [User],
  synchronize: false,
  logging: false,
});