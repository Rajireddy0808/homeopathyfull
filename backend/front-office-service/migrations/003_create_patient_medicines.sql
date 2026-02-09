-- Migration: Create patient_medicines table
-- Created: $(date)

CREATE TABLE IF NOT EXISTS patient_medicines (
    id SERIAL PRIMARY KEY,
    patient_prescription_id INTEGER NOT NULL,
    medicine_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign key constraint
    CONSTRAINT fk_patient_medicines_prescription 
        FOREIGN KEY (patient_prescription_id) 
        REFERENCES patient_prescriptions(id) 
        ON DELETE CASCADE
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_patient_medicines_prescription_id 
    ON patient_medicines(patient_prescription_id);
CREATE INDEX IF NOT EXISTS idx_patient_medicines_medicine_id 
    ON patient_medicines(medicine_id);

-- Create unique constraint to prevent duplicate medicine prescriptions
CREATE UNIQUE INDEX IF NOT EXISTS idx_patient_medicines_unique 
    ON patient_medicines(patient_prescription_id, medicine_id);

-- Create trigger to automatically update updated_at column
CREATE TRIGGER update_patient_medicines_updated_at 
    BEFORE UPDATE ON patient_medicines 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();