-- Create patient_examination table
CREATE TABLE IF NOT EXISTS patient_examination (
    id SERIAL PRIMARY KEY,
    patient_id VARCHAR(50) NOT NULL,
    location_id INTEGER NOT NULL,
    past_medical_reports TEXT,
    investigations_required TEXT,
    physical_examination TEXT,
    bp VARCHAR(20),
    pulse VARCHAR(20),
    heart_rate VARCHAR(20),
    weight VARCHAR(20),
    rr VARCHAR(20),
    menstrual_obstetric_history TEXT,
    created_by INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (location_id) REFERENCES locations(id),
    FOREIGN KEY (created_by) REFERENCES users(id)
);

-- Create index for better performance
CREATE INDEX IF NOT EXISTS idx_patient_examination_patient_id ON patient_examination(patient_id);
CREATE INDEX IF NOT EXISTS idx_patient_examination_location_id ON patient_examination(location_id);
CREATE INDEX IF NOT EXISTS idx_patient_examination_created_at ON patient_examination(created_at);

-- Add trigger to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_patient_examination_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_patient_examination_updated_at
    BEFORE UPDATE ON patient_examination
    FOR EACH ROW
    EXECUTE FUNCTION update_patient_examination_updated_at();