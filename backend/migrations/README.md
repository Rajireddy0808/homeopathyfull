# HIMS Microservices Database Migrations

This directory contains database migration scripts for all HIMS microservices.

## Microservices Database Structure

### 1. User Management & Settings Service
- **Database**: `hims_user_settings` (Already created)
- **Tables**: users, roles, locations, system_settings, user_shifts, shifts, communications

### 2. Patient Management Service
- **Database**: `hims_patient_management`
- **Migration**: `patient-management/001_create_patient_management_schema.sql`
- **Tables**: patients, patient_portal_access, patient_health_records, patient_support_tickets, patient_queue, patient_transfers

### 3. Billing Service
- **Database**: `hims_billing`
- **Migration**: `billing/001_create_billing_schema.sql`
- **Tables**: bills, bill_items, services, packages, discounts, estimates, quick_bills, cashier_transactions, billing_accounts, price_lists

### 4. Appointments Service
- **Database**: `hims_appointments`
- **Migration**: `appointments/001_create_appointments_schema.sql`
- **Tables**: appointments, doctor_schedules, doctor_rounds, queue_tokens, shifts, user_shifts, departments

### 5. Clinical Service
- **Database**: `hims_clinical`
- **Migration**: `clinical/001_create_clinical_schema.sql`
- **Tables**: vitals, prescriptions, prescription_items, prescription_templates, investigations, admissions, bed_transfers, communications

### 6. Laboratory Service
- **Database**: `hims_laboratory`
- **Migration**: `laboratory/001_create_laboratory_schema.sql`
- **Tables**: lab_tests, lab_orders, lab_order_items, lab_equipment, lab_reagents, lab_quality_control, lab_sample_tracking

### 7. Pharmacy Service
- **Database**: `hims_pharmacy`
- **Migration**: `pharmacy/001_create_pharmacy_schema.sql`
- **Tables**: medicines, pharmacy_sales, central_pharmacy_items, pharmacy_indents, medicine_interactions, medicine_allergies, stock_movements

### 8. Insurance Service
- **Database**: `hims_insurance`
- **Migration**: `insurance/001_create_insurance_schema.sql`
- **Tables**: insurance_companies, tpa_companies, insurance_rates, pre_authorizations, insurance_claims, insurance_policies, insurance_eligibility_checks

### 9. Inpatient Service
- **Database**: `hims_inpatient`
- **Migration**: `inpatient/001_create_inpatient_schema.sql`
- **Tables**: beds, advance_collections, inpatient_census, wards, bed_reservations, discharge_planning, nursing_notes, patient_care_plans

### 10. Material Management Service
- **Database**: `hims_material_management`
- **Migration**: `material-management/001_create_material_management_schema.sql`
- **Tables**: vendors, items, purchase_orders, grn, stock_adjustments, stock_transfers, rfq, contracts, material_schemes, ai_insights

### 11. Telecaller Service
- **Database**: `hims_telecaller`
- **Migration**: `telecaller/001_create_telecaller_schema.sql`
- **Tables**: telecaller_campaigns, telecaller_followups, call_logs, leads, sms_campaigns, appointment_reminders, customer_feedback

## Running Migrations

### Prerequisites
- PostgreSQL server running
- Database user with CREATE DATABASE privileges
- psql command line tool

### Execution Order
1. User Management Service (Already done)
2. Patient Management Service
3. Billing Service
4. Appointments Service
5. Clinical Service
6. Laboratory Service
7. Pharmacy Service
8. Insurance Service
9. Inpatient Service
10. Material Management Service
11. Telecaller Service

### Running Individual Migrations
```bash
# Example: Run Patient Management migration
psql -h api.vithyou.com -U vithyouuser -f patient-management/001_create_patient_management_schema.sql

# Example: Run Billing migration
psql -h api.vithyou.com -U vithyouuser -f billing/001_create_billing_schema.sql
```

### Running All Migrations
```bash
# Run all migrations in order
for service in patient-management billing appointments clinical laboratory pharmacy insurance inpatient material-management telecaller; do
    echo "Running migration for $service..."
    psql -h api.vithyou.com -U vithyouuser -f $service/001_create_${service//-/_}_schema.sql
done
```

## Cross-Service Communication

### Shared Data Strategy
- Each service has its own `locations` table (replicated)
- Services communicate via REST APIs
- Use patient_id, location_id as common identifiers
- No direct database access between services

### API Endpoints Pattern
```
Patient Service: /api/patients/{id}
Billing Service: /api/bills/{id}
Appointment Service: /api/appointments/{id}
```

### Event-Driven Updates
- Use message queues for data synchronization
- Publish events for critical data changes
- Implement eventual consistency model

## Environment Configuration

Each service should have its own environment configuration:

```env
# Example for Patient Management Service
NODE_ENV=development
DB_HOST=api.vithyou.com
DB_PORT=5432
DB_USERNAME=vithyouuser
DB_PASSWORD=Veeg@M@123
DB_NAME=hims_patient_management
PORT=3002
```

## Notes
- All tables include proper indexes for performance
- Foreign key constraints maintain data integrity
- Each service is completely independent
- Location-based multi-tenancy supported
- Audit trails included with created_at/updated_at timestamps