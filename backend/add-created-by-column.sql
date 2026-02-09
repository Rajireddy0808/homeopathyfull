-- Add created_by column to existing patients table
ALTER TABLE patients ADD COLUMN IF NOT EXISTS created_by INTEGER;

-- Add comment for the new column
COMMENT ON COLUMN patients.created_by IS 'Employee ID of the user who created this patient record';

-- Create index for better performance
CREATE INDEX IF NOT EXISTS idx_patients_created_by ON patients(created_by);