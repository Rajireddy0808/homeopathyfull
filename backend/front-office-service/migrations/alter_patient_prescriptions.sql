-- ALTER script to change user_id to patient_id in patient_prescriptions table
-- Execute this if the table was already created with user_id

-- Drop existing index
DROP INDEX IF EXISTS idx_patient_prescriptions_user_id;

-- Rename column from user_id to patient_id
ALTER TABLE patient_prescriptions 
RENAME COLUMN user_id TO patient_id;

-- Add foreign key constraint to patients table
ALTER TABLE patient_prescriptions 
ADD CONSTRAINT fk_patient_prescriptions_patient 
FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE;

-- Create new index on patient_id
CREATE INDEX idx_patient_prescriptions_patient_id ON patient_prescriptions(patient_id);

SELECT 'Successfully altered patient_prescriptions table: user_id renamed to patient_id with foreign key constraint' AS result;