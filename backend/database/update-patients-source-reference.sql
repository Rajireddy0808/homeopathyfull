-- Update patients table to reference patient_source table by ID
-- This migration adds a foreign key relationship between patients and patient_source

-- Step 1: Add patient_source_id column to patients table
ALTER TABLE patients ADD COLUMN IF NOT EXISTS patient_source_id INTEGER;

-- Step 2: Update existing records to map source strings to patient_source IDs
UPDATE patients 
SET patient_source_id = ps.id 
FROM patient_source ps 
WHERE UPPER(patients.source) = UPPER(ps.code) 
   OR UPPER(patients.source) = UPPER(ps.title);

-- Step 3: Set default patient_source_id for records without a match
UPDATE patients 
SET patient_source_id = (SELECT id FROM patient_source WHERE code = 'WALK_IN' LIMIT 1)
WHERE patient_source_id IS NULL;

-- Step 4: Add foreign key constraint
ALTER TABLE patients 
ADD CONSTRAINT fk_patients_patient_source 
FOREIGN KEY (patient_source_id) REFERENCES patient_source(id);

-- Step 5: Create index for better performance
CREATE INDEX IF NOT EXISTS idx_patients_patient_source_id ON patients(patient_source_id);

-- Step 6: Drop the old source column (optional - uncomment if you want to remove it)
-- ALTER TABLE patients DROP COLUMN IF EXISTS source;

COMMENT ON COLUMN patients.patient_source_id IS 'Foreign key reference to patient_source table';