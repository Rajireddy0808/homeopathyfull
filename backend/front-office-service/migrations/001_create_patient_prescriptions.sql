-- Migration: Create patient_prescriptions table
-- Created: $(date)

CREATE TABLE IF NOT EXISTS patient_prescriptions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    vitals_temperature DECIMAL(4,1),
    vitals_blood_pressure VARCHAR(20),
    vitals_heart_rate INTEGER,
    vitals_o2_saturation DECIMAL(5,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create index on user_id for better query performance
CREATE INDEX IF NOT EXISTS idx_patient_prescriptions_user_id ON patient_prescriptions(user_id);

-- Create trigger to automatically update updated_at column
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