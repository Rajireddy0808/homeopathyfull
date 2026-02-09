# HIMS Backend - Hospital Information Management System

## Overview
NestJS-based microservice backend for Hospital Information Management System with PostgreSQL database.

## Architecture
- **Framework**: NestJS with TypeScript
- **Database**: PostgreSQL with TypeORM
- **Authentication**: JWT-based authentication
- **API Documentation**: Swagger/OpenAPI

## Modules

### Core Modules
- **Auth Module**: User authentication and authorization
- **Patients Module**: Patient registration and management
- **Appointments Module**: Appointment scheduling and management
- **Billing Module**: Bill generation and payment processing
- **Pharmacy Module**: Medicine inventory and prescription management

### Specialized Modules
- **Lab Module**: Laboratory test management
- **Inpatient Module**: Bed management and admissions
- **Insurance Module**: Insurance claims and TPA management
- **Material Management Module**: Inventory and procurement
- **Doctors Module**: Doctor-specific functionalities
- **Front Office Module**: Reception and customer service
- **Telecaller Module**: Call center and follow-ups
- **Reports Module**: Analytics and reporting

## Database Schema

### Core Tables
- `users` - System users with role-based access
- `patients` - Patient demographics and medical info
- `appointments` - Appointment scheduling
- `bills` & `bill_items` - Billing and invoicing
- `medicines` - Medicine inventory
- `prescriptions` & `prescription_items` - Prescription management

### Extended Tables
- `lab_tests` & `lab_orders` - Laboratory management
- `beds` & `admissions` - Inpatient management
- `insurance_companies` & `insurance_claims` - Insurance processing

## Setup Instructions

### Prerequisites
- Node.js (v18+)
- PostgreSQL (v13+)
- npm or yarn

### Installation
1. Install dependencies:
```bash
npm install
```

2. Setup PostgreSQL database:
```bash
# Create database and run schema
psql -U postgres -f database/schema.sql
psql -U postgres -d hims_db -f database/sample-data.sql
```

3. Configure environment variables:
```bash
cp .env.example .env
# Edit .env with your database credentials
```

4. Start the application:
```bash
# Development
npm run start:dev

# Production
npm run build
npm run start:prod
```

## API Endpoints

### Authentication
- `POST /auth/login` - User login
- `POST /auth/register` - User registration

### Patients
- `GET /patients` - List all patients
- `POST /patients` - Create new patient
- `GET /patients/:id` - Get patient details
- `PATCH /patients/:id` - Update patient
- `DELETE /patients/:id` - Delete patient

### Appointments
- `GET /appointments` - List appointments
- `POST /appointments` - Create appointment
- `GET /appointments/:id` - Get appointment details
- `PATCH /appointments/:id` - Update appointment

## User Roles
- **admin** - Full system access
- **doctor** - Patient care, prescriptions, appointments
- **nurse** - Patient care, vitals, medication administration
- **pharmacist** - Medicine dispensing, inventory
- **lab_technician** - Lab tests, results
- **front_office** - Patient registration, appointments
- **telecaller** - Follow-ups, appointment booking
- **billing** - Bill generation, payments
- **material_manager** - Inventory, procurement

## Security Features
- JWT-based authentication
- Role-based access control
- Password hashing with bcrypt
- Input validation with class-validator
- SQL injection prevention with TypeORM

## API Documentation
Access Swagger documentation at: `http://localhost:3001/api`

## Environment Variables
```
NODE_ENV=development
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=password
DB_NAME=hims_db
JWT_SECRET=your-jwt-secret-key
JWT_EXPIRES_IN=24h
```

## Sample Data
The database includes sample data for:
- 9 system users with different roles
- 5 sample patients with medical history
- Medicine inventory with 5 common medications
- Lab tests and procedures
- Bed management data
- Insurance companies
- Sample appointments, prescriptions, and bills

## Development
```bash
# Watch mode
npm run start:dev

# Run tests
npm run test

# Generate migration
npm run typeorm migration:generate -- -n MigrationName

# Run migration
npm run typeorm migration:run
```