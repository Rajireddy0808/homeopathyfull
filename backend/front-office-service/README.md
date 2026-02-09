# Front Office Service (Patient Management Service)

HIMS Front Office microservice that handles patient management, queue management, and front-office operations.

**Note**: This service uses the `hims_patient_management` database and IS the patient management service for the system.

## Features

- **Patient Management**: Complete patient CRUD operations
- **Queue Management**: Token-based patient queue system
- **Patient Search**: Advanced patient search capabilities
- **Patient History**: Aggregated patient data from other services
- **Front Office Dashboard**: Real-time dashboard for reception staff

## Database

- **Database**: `hims_patient_management`
- **Port**: 3003
- **Tables**: patients, patient_queue, patient_transfers, patient_support_tickets, locations

## API Endpoints

### Patient Management
- `GET /api/patients` - List patients
- `GET /api/patients/search` - Search patients
- `GET /api/patients/:id` - Get patient details
- `GET /api/patients/:id/history` - Get patient history (aggregated from other services)
- `GET /api/patients/stats` - Get patient statistics

### Queue Management
- `POST /api/queue/tokens` - Create queue token
- `GET /api/queue/tokens` - Get queue tokens
- `POST /api/queue/call-next` - Call next patient
- `PUT /api/queue/tokens/:id/status` - Update token status
- `GET /api/queue/stats` - Get queue statistics

### Front Office Dashboard
- `GET /api/front-office/dashboard` - Get dashboard data
- `GET /api/front-office/patient-search` - Search patients
- `GET /api/front-office/services` - Get services from billing service
- `POST /api/front-office/quick-appointment` - Create appointment via appointment service

## Service Architecture

This service acts as:
1. **Primary Patient Service** - Manages all patient data
2. **Front Office Service** - Handles reception operations
3. **Queue Management Service** - Manages patient queues
4. **Integration Hub** - Aggregates data from other services for patient history

## External Service Communication

Communicates with:
- **User Service** (port 3001) - Authentication and user data
- **Billing Service** (port 3004) - Services, packages, bills
- **Appointment Service** (port 3005) - Appointments, schedules
- **Clinical Service** (port 3006) - Vitals, prescriptions
- **Laboratory Service** (port 3007) - Lab orders and results
- **Pharmacy Service** (port 3008) - Pharmacy sales

## Environment Variables

```env
NODE_ENV=development
DB_HOST=api.vithyou.com
DB_PORT=5432
DB_USERNAME=vithyouuser
DB_PASSWORD=Veeg@M@123
DB_NAME=hims_patient_management
PORT=3003

# External Services
USER_SERVICE_URL=http://localhost:3001
BILLING_SERVICE_URL=http://localhost:3004
APPOINTMENT_SERVICE_URL=http://localhost:3005
CLINICAL_SERVICE_URL=http://localhost:3006
LABORATORY_SERVICE_URL=http://localhost:3007
PHARMACY_SERVICE_URL=http://localhost:3008
```

## Installation & Running

```bash
# Install dependencies
npm install

# Start development server
npm run start:dev

# Build for production
npm run build
npm run start:prod
```

## Frontend Integration

Frontend should connect to this service for:
- Patient registration and management
- Patient search functionality
- Queue token management
- Front office dashboard data

API Base URL: `http://localhost:3003`