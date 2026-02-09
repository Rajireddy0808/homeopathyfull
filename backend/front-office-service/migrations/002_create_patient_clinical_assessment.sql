-- Migration: Create patient_clinical_assessment table
-- Created: $(date)

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