-- Complete migration script for patient prescription system
-- Execute this entire script in your PostgreSQL database: hims_patient_management

-- Create update trigger function first
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 1. Create patient_prescriptions table
CREATE TABLE IF NOT EXISTS patient_prescriptions (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER NOT NULL,
    vitals_temperature DECIMAL(4,1),
    vitals_blood_pressure VARCHAR(20),
    vitals_heart_rate INTEGER,
    vitals_o2_saturation DECIMAL(5,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign key constraint to patients table
    CONSTRAINT fk_patient_prescriptions_patient 
        FOREIGN KEY (patient_id) 
        REFERENCES patients(id) 
        ON DELETE CASCADE
);

-- Create index on patient_id for better query performance
CREATE INDEX IF NOT EXISTS idx_patient_prescriptions_patient_id ON patient_prescriptions(patient_id);

-- Create trigger to automatically update updated_at column
CREATE TRIGGER update_patient_prescriptions_updated_at 
    BEFORE UPDATE ON patient_prescriptions 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 2. Create patient_clinical_assessment table
CREATE TABLE IF NOT EXISTS patient_clinical_assessment (
    id SERIAL PRIMARY KEY,
    patient_prescription_id INTEGER NOT NULL,
    chief_complaint TEXT,
    diagnosis TEXT,
    examination_findings TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign key constraint
    CONSTRAINT fk_patient_clinical_assessment_prescription 
        FOREIGN KEY (patient_prescription_id) 
        REFERENCES patient_prescriptions(id) 
        ON DELETE CASCADE
);

-- Create index on patient_prescription_id for better query performance
CREATE INDEX IF NOT EXISTS idx_patient_clinical_assessment_prescription_id 
    ON patient_clinical_assessment(patient_prescription_id);

-- Create trigger to automatically update updated_at column
CREATE TRIGGER update_patient_clinical_assessment_updated_at 
    BEFORE UPDATE ON patient_clinical_assessment 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 3. Create patient_medicines table
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

-- Display success message
SELECT 'Migration completed successfully! Tables created: patient_prescriptions, patient_clinical_assessment, patient_medicines' AS result;