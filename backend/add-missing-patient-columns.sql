-- Add missing columns to existing patients table based on UI
ALTER TABLE patients ADD COLUMN IF NOT EXISTS medical_conditions TEXT;
ALTER TABLE patients ADD COLUMN IF NOT EXISTS fee VARCHAR(50);
ALTER TABLE patients ADD COLUMN IF NOT EXISTS fee_type VARCHAR(50);
ALTER TABLE patients ADD COLUMN IF NOT EXISTS occupation VARCHAR(100);
ALTER TABLE patients ADD COLUMN IF NOT EXISTS specialization VARCHAR(100);
ALTER TABLE patients ADD COLUMN IF NOT EXISTS doctor VARCHAR(100);
ALTER TABLE patients ADD COLUMN IF NOT EXISTS status VARCHAR(20) DEFAULT 'active';

-- Update existing records to have active status
UPDATE patients SET status = 'active' WHERE status IS NULL;

-- Create trigger for updated_at if it doesn't exist
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

DROP TRIGGER IF EXISTS update_patients_updated_at ON patients;
CREATE TRIGGER update_patients_updated_at 
    BEFORE UPDATE ON patients 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();