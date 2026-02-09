-- Clinical Service Database Schema
-- Database: hims_clinical

CREATE DATABASE hims_clinical;
\c hims_clinical;

-- Locations (replicated for reference)
CREATE TABLE locations (
    id SERIAL PRIMARY KEY,
    location_code VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    address TEXT NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Vitals table
CREATE TABLE vitals (
    id SERIAL PRIMARY KEY,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    patient_id INTEGER NOT NULL,
    appointment_id INTEGER,
    recorded_by INTEGER NOT NULL,
    height DECIMAL(5,2),
    weight DECIMAL(5,2),
    bmi DECIMAL(5,2),
    temperature DECIMAL(4,1),
    blood_pressure_systolic INTEGER,
    blood_pressure_diastolic INTEGER,
    pulse_rate INTEGER,
    respiratory_rate INTEGER,
    oxygen_saturation DECIMAL(5,2),
    blood_sugar DECIMAL(6,2),
    notes TEXT,
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Prescriptions table
CREATE TABLE prescriptions (
    id SERIAL PRIMARY KEY,
    prescription_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    patient_id INTEGER NOT NULL,
    doctor_id INTEGER NOT NULL,
    appointment_id INTEGER,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'dispensed', 'partially_dispensed', 'cancelled')),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(prescription_number, location_id)
);

-- Prescription items table
CREATE TABLE prescription_items (
    id SERIAL PRIMARY KEY,
    prescription_id INTEGER NOT NULL REFERENCES prescriptions(id) ON DELETE CASCADE,
    medicine_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    dosage VARCHAR(50) NOT NULL,
    frequency VARCHAR(50) NOT NULL,
    duration INTEGER NOT NULL,
    instructions TEXT
);

-- Prescription templates table
CREATE TABLE prescription_templates (
    id SERIAL PRIMARY KEY,
    template_name VARCHAR(100) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    doctor_id INTEGER NOT NULL,
    diagnosis VARCHAR(255),
    template_data JSONB NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Investigations table
CREATE TABLE investigations (
    id SERIAL PRIMARY KEY,
    investigation_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    patient_id INTEGER NOT NULL,
    doctor_id INTEGER NOT NULL,
    investigation_type VARCHAR(50) NOT NULL CHECK (investigation_type IN ('radiology', 'pathology', 'cardiology', 'endoscopy')),
    title VARCHAR(200) NOT NULL,
    description TEXT,
    status VARCHAR(20) DEFAULT 'ordered' CHECK (status IN ('ordered', 'scheduled', 'in_progress', 'completed', 'cancelled')),
    scheduled_date TIMESTAMP,
    completed_date TIMESTAMP,
    report_url VARCHAR(500),
    findings TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(investigation_number, location_id)
);

-- Admissions table
CREATE TABLE admissions (
    id SERIAL PRIMARY KEY,
    admission_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    patient_id INTEGER NOT NULL,
    bed_id INTEGER NOT NULL,
    doctor_id INTEGER NOT NULL,
    admission_date TIMESTAMP NOT NULL,
    discharge_date TIMESTAMP,
    status VARCHAR(20) DEFAULT 'admitted' CHECK (status IN ('admitted', 'discharged', 'transferred')),
    admission_type VARCHAR(20) NOT NULL CHECK (admission_type IN ('emergency', 'planned', 'transfer')),
    diagnosis TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(admission_number, location_id)
);

-- Bed transfers table
CREATE TABLE bed_transfers (
    id SERIAL PRIMARY KEY,
    admission_id INTEGER NOT NULL REFERENCES admissions(id),
    from_bed_id INTEGER NOT NULL,
    to_bed_id INTEGER NOT NULL,
    transfer_date TIMESTAMP NOT NULL,
    reason TEXT,
    transferred_by INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Communications table
CREATE TABLE communications (
    id SERIAL PRIMARY KEY,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    from_user_id INTEGER NOT NULL,
    to_user_id INTEGER,
    patient_id INTEGER,
    subject VARCHAR(255),
    message TEXT NOT NULL,
    priority VARCHAR(20) DEFAULT 'normal' CHECK (priority IN ('low', 'normal', 'high', 'urgent')),
    is_read BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX idx_vitals_patient_id ON vitals(patient_id);
CREATE INDEX idx_vitals_location ON vitals(location_id);
CREATE INDEX idx_prescriptions_location ON prescriptions(location_id);
CREATE INDEX idx_prescriptions_patient_id ON prescriptions(patient_id);
CREATE INDEX idx_prescriptions_doctor_id ON prescriptions(doctor_id);
CREATE INDEX idx_prescription_templates_location ON prescription_templates(location_id);
CREATE INDEX idx_prescription_templates_doctor ON prescription_templates(doctor_id);
CREATE INDEX idx_investigations_location ON investigations(location_id);
CREATE INDEX idx_investigations_patient ON investigations(patient_id);
CREATE INDEX idx_admissions_location ON admissions(location_id);
CREATE INDEX idx_admissions_patient_id ON admissions(patient_id);
CREATE INDEX idx_admissions_bed_id ON admissions(bed_id);
CREATE INDEX idx_communications_location ON communications(location_id);