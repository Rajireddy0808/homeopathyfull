-- Run all migrations for patient prescription system
-- Execute this file to create all required tables

\echo 'Starting migration process...'

-- Run migration 001: Create patient_prescriptions table
\echo 'Creating patient_prescriptions table...'
\i 001_create_patient_prescriptions.sql

-- Run migration 002: Create patient_clinical_assessment table
\echo 'Creating patient_clinical_assessment table...'
\i 002_create_patient_clinical_assessment.sql

-- Run migration 003: Create patient_medicines table
\echo 'Creating patient_medicines table...'
\i 003_create_patient_medicines.sql

\echo 'Migration process completed successfully!'
\echo 'Tables created:'
\echo '- patient_prescriptions'
\echo '- patient_clinical_assessment'
\echo '- patient_medicines'