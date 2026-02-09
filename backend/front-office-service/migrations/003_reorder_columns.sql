-- Reorder columns to move created_at and updated_at to the end
-- PostgreSQL doesn't support column reordering directly, so we recreate the table

-- Create new table with desired column order
CREATE TABLE patient_prescriptions_new (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER NOT NULL,
    vitals_temperature DECIMAL(4,1),
    vitals_blood_pressure VARCHAR(20),
    vitals_heart_rate INTEGER,
    vitals_o2_saturation DECIMAL(5,2),
    vitals_respiratory_rate INTEGER,
    vitals_weight DECIMAL(5,2),
    vitals_height INTEGER,
    vitals_blood_glucose INTEGER,
    vitals_pain_scale INTEGER,
    nursing_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Copy data from old table
INSERT INTO patient_prescriptions_new 
SELECT id, patient_id, vitals_temperature, vitals_blood_pressure, vitals_heart_rate, 
       vitals_o2_saturation, vitals_respiratory_rate, vitals_weight, vitals_height, 
       vitals_blood_glucose, vitals_pain_scale, nursing_notes, created_at, updated_at
FROM patient_prescriptions;

-- Drop old table and rename new one
DROP TABLE patient_prescriptions;
ALTER TABLE patient_prescriptions_new RENAME TO patient_prescriptions;

-- Recreate indexes and triggers
CREATE INDEX idx_patient_prescriptions_patient_id ON patient_prescriptions(patient_id);

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_patient_prescriptions_updated_at 
    BEFORE UPDATE ON patient_prescriptions 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

SELECT 'Successfully reordered columns - created_at and updated_at are now at the end' AS result;