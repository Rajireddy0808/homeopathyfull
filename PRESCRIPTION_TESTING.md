# Prescription System Testing Guide

## Backend Setup

1. **Add Sample Patient Data**
   - Run the SQL file: `backend/front-office-service/sample-patients.sql`
   - This adds 7 sample patients with realistic data including allergies and medical history

2. **Start Backend Services**
   ```bash
   cd backend/front-office-service
   npm run start:dev
   ```

## Frontend Testing

1. **Navigate to Prescription Create Page**
   - Go to: `/admin/prescriptions/create`

2. **Test Patient Search**
   - Try searching for:
     - Names: "James", "Maria", "Jennifer"
     - Phone numbers: "9876543210", "9876543212"
     - Patient IDs: "P24010001", "P24010002"

3. **Expected Features**
   - Real-time search with 300ms debounce
   - Loading spinner during API calls
   - Debug information showing search term and result count
   - Patient cards with:
     - Name, age, gender
     - Phone number and address
     - Token number and department
     - Allergy warnings (red badges)
     - Payment amount and last visit

## Sample Patient Data

| Patient ID | Name | Phone | Allergies | Medical History |
|------------|------|-------|-----------|-----------------|
| P24010001 | James Wilson | +91-9876543210 | Penicillin, Peanuts | Hypertension, Diabetes |
| P24010002 | Maria Garcia | +91-9876543212 | Aspirin | Asthma |
| P24010003 | Jennifer Brown | +91-9876543214 | Shellfish | Migraine, Anxiety |
| P24010004 | Michael Johnson | +91-9876543216 | None | None |
| P24010005 | Sarah Thompson | +91-9876543218 | Latex | Chronic migraine |

## API Endpoint

- **URL**: `GET /api/patients/search-for-prescription`
- **Parameters**: 
  - `query`: Search term (name, phone, patient ID)
  - `locationId`: Branch/location ID (defaults to 1)
- **Response**: Array of patient objects with enhanced data for prescription interface

## Troubleshooting

1. **No search results**: Check if sample data is inserted in database
2. **API errors**: Verify backend service is running on correct port
3. **Branch context issues**: System falls back to location ID 1 if no branch selected