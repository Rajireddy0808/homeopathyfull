-- Drop old patients table and create new one
DROP TABLE IF EXISTS patients CASCADE;

CREATE TABLE patients (
    id SERIAL PRIMARY KEY,
    patient_id VARCHAR(20) UNIQUE NOT NULL,
    
    -- Personal Information
    salutation VARCHAR(10),
    first_name VARCHAR(100) NOT NULL,
    middle_name VARCHAR(100),
    last_name VARCHAR(100) NOT NULL,
    father_spouse_name VARCHAR(200),
    
    -- Demographics
    gender VARCHAR(10) NOT NULL,
    date_of_birth DATE,
    blood_group VARCHAR(10),
    marital_status VARCHAR(20),
    
    -- Contact Information
    mobile VARCHAR(15) NOT NULL,
    email VARCHAR(255),
    emergency_contact VARCHAR(15),
    
    -- Address Information
    address1 TEXT NOT NULL,
    district VARCHAR(100) DEFAULT 'HYDERABAD',
    state VARCHAR(100) DEFAULT 'TELANGANA',
    country VARCHAR(100) DEFAULT 'INDIA',
    pin_code VARCHAR(10) NOT NULL,
    
    -- Medical Information
    medical_history TEXT,
    medical_conditions TEXT,
    
    -- Registration Information
    fee VARCHAR(50),
    fee_type VARCHAR(50),
    source VARCHAR(100),
    occupation VARCHAR(100),
    specialization VARCHAR(100),
    doctor VARCHAR(100),
    
    -- System Fields
    location_id INTEGER NOT NULL,
    created_by INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'active'
);

-- Create indexes
CREATE INDEX idx_patients_patient_id ON patients(patient_id);
CREATE INDEX idx_patients_mobile ON patients(mobile);
CREATE INDEX idx_patients_location_id ON patients(location_id);
CREATE INDEX idx_patients_created_by ON patients(created_by);
CREATE INDEX idx_patients_status ON patients(status);

-- Create trigger for updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_patients_updated_at 
    BEFORE UPDATE ON patients 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();