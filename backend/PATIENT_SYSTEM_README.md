# Patient Management System

## Overview
This document describes the improved patient management system with a redesigned database structure, enhanced API, and modern UI.

## Database Changes

### New Patient Table Structure
The patients table has been completely redesigned with the following improvements:

#### Key Features:
- **Organized Columns**: Grouped into logical sections (Personal, Demographics, Contact, Address, Medical, Registration, System)
- **created_by Column**: Tracks which employee created each patient record
- **Proper Constraints**: Data validation at database level
- **Indexes**: Optimized for performance
- **Auto-generated Patient IDs**: Format P0001, P0002, etc.

#### Table Columns:
```sql
-- Personal Information
salutation, first_name, middle_name, last_name, father_spouse_name

-- Demographics  
gender, date_of_birth, blood_group, marital_status

-- Contact Information
mobile, email, emergency_contact

-- Address Information
address1, district, state, country, pin_code

-- Medical Information
medical_history, medical_conditions

-- Registration Information
fee_type, source, occupation, specialization, doctor

-- System Information
location_id, created_by, created_at, updated_at
```

## API Changes

### Updated Endpoints

#### POST /patients/register
**New Features:**
- Accepts `created_by` parameter from authenticated user
- Validates all required fields
- Returns patient ID and name in response
- Improved error handling

**Request Body:**
```json
{
  "salutation": "mr",
  "firstName": "John",
  "middleName": "Michael",
  "lastName": "Doe",
  "fatherSpouseName": "Robert Doe",
  "gender": "male",
  "mobile": "9876543210",
  "email": "john.doe@email.com",
  "dateOfBirth": "1990-01-15",
  "bloodGroup": "o+",
  "maritalStatus": "single",
  "address1": "123 Main Street, Apartment 4B",
  "district": "HYDERABAD",
  "state": "TELANGANA", 
  "country": "INDIA",
  "pinCode": "500001",
  "emergencyContact": "9876543211",
  "medicalHistory": "No significant medical history",
  "medicalConditions": "None",
  "feeType": "cash",
  "source": "walk-in",
  "occupation": "Software Engineer",
  "specialization": "Technology",
  "doctor": "dr-smith"
}
```

**Response:**
```json
{
  "message": "Patient registered successfully",
  "patient": {
    "id": 1,
    "patientId": "P0001",
    "name": "John Doe"
  }
}
```

## Frontend Changes

### New UI Features

#### Organized Layout
- **Sectioned Cards**: Information grouped into logical sections
- **Icons**: Visual indicators for each section
- **Responsive Design**: Works on all screen sizes
- **Better Validation**: Real-time field validation

#### Sections:
1. **Personal Information** 👤
   - Title, names, gender, date of birth, age calculation

2. **Contact Information** 📞
   - Mobile, email, emergency contact

3. **Address Information** 📍
   - Complete address with PIN code

4. **Medical Information** ❤️
   - Blood group, marital status, medical history/conditions

5. **Registration Information** 💼
   - Fee category, payment type, source, occupation, doctor assignment

#### Improved Features:
- Auto-age calculation from date of birth
- Better form validation
- Loading states
- Success/error messages
- Responsive grid layout
- Proper accessibility labels

## Migration Instructions

### Option 1: Using Batch Script
```bash
cd hims\backend
run-patient-migration.bat
```

### Option 2: Using JavaScript
```bash
cd hims\backend
node migrate-patients-table.js
```

### Option 3: Manual SQL
```bash
psql -h localhost -U postgres -d hims_db -f database/create-patients-table.sql
```

## Validation Rules

### Required Fields:
- first_name
- last_name  
- gender
- mobile (10 digits)
- address1
- pin_code (6 digits)

### Optional Fields:
- All other fields are optional but recommended for complete patient records

### Data Constraints:
- Gender: 'male', 'female', 'other'
- Mobile: Minimum 10 digits
- PIN Code: Exactly 6 digits
- Patient ID: Auto-generated (P0001, P0002, etc.)

## Security Features

### Authentication:
- JWT token required for all API calls
- User location validation
- Employee ID tracking via created_by

### Data Protection:
- Input validation at multiple levels
- SQL injection prevention
- XSS protection in frontend

## Performance Optimizations

### Database:
- Indexes on frequently queried columns
- Optimized patient ID generation
- Efficient data types

### Frontend:
- Lazy loading of master data
- Debounced input validation
- Optimized re-renders

## Testing

### API Testing:
```bash
# Test patient registration
curl -X POST http://localhost:3001/patients/register \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{"firstName":"Test","lastName":"Patient","gender":"male","mobile":"9876543210","address1":"Test Address","pinCode":"500001"}'
```

### Frontend Testing:
1. Navigate to `/admin/front-office/registration`
2. Fill out the form with test data
3. Verify all sections work correctly
4. Test form validation
5. Confirm successful registration

## Troubleshooting

### Common Issues:

1. **Migration Fails**
   - Check database connection
   - Verify PostgreSQL is running
   - Check user permissions

2. **API Returns 401**
   - Verify JWT token is valid
   - Check user has proper permissions
   - Confirm location_id is set

3. **Frontend Validation Errors**
   - Check required fields are filled
   - Verify mobile number format
   - Confirm PIN code is 6 digits

### Support:
For issues or questions, check the application logs and database constraints.