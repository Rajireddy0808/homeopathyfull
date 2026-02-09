import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  
  app.useGlobalPipes(new ValidationPipe());
  app.enableCors();
  
  const config = new DocumentBuilder()
    .setTitle('HIMS API')
    .setDescription('Hospital Information Management System API')
    .setVersion('1.0')
    .addBearerAuth()
    .build();
  
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, document);
  
  const port = process.env.PORT || 3002;
  await app.listen(port, '0.0.0.0'); // Bind to all network interfaces
  console.log(`Application is running on: http://localhost:${port}`);
  console.log(`Network access: http://0.0.0.0:${port}`);
  console.log(`Swagger documentation: http://localhost:${port}/api`);
}
bootstrap();