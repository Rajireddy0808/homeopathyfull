import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  
  // Enable CORS
  app.enableCors({
    origin: true,
    credentials: true,
  });

  // Global validation pipe
  app.useGlobalPipes(new ValidationPipe({
    transform: true,
    whitelist: true,
  }));

  // Set global prefix
  app.setGlobalPrefix('front-office');

  const configService = app.get(ConfigService);
  const port = configService.get('PORT') || 3003;

  await app.listen(port);
  console.log(`Front Office Service is running on: http://localhost:${port}`);
}
bootstrap();