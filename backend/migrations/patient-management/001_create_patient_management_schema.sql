-- Patient Management Service Database Schema
-- Database: hims_patient_management

CREATE DATABASE hims_patient_management;
\c hims_patient_management;

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

-- Patients table
CREATE TABLE patients (
    id SERIAL PRIMARY KEY,
    patient_unique_id VARCHAR(20),
    location_id INTEGER NOT NULL REFERENCES locations(id),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(10) NOT NULL CHECK (gender IN ('male', 'female', 'other')),
    phone VARCHAR(15) NOT NULL,
    email VARCHAR(100),
    address TEXT NOT NULL,
    emergency_contact VARCHAR(15),
    blood_group VARCHAR(5) CHECK (blood_group IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')),
    allergies TEXT,
    medical_history TEXT,
    insurance_number VARCHAR(50),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(patient_unique_id, location_id)
);

-- Patient portal access
CREATE TABLE patient_portal_access (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER NOT NULL REFERENCES patients(id),
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    is_active BOOLEAN DEFAULT true,
    last_login TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Patient health records
CREATE TABLE patient_health_records (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER NOT NULL REFERENCES patients(id),
    record_type VARCHAR(50) NOT NULL CHECK (record_type IN ('vaccination', 'surgery', 'allergy', 'medication', 'condition')),
    title VARCHAR(200) NOT NULL,
    description TEXT,
    date_recorded DATE NOT NULL,
    doctor_id INTEGER,
    is_visible_to_patient BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Patient support tickets
CREATE TABLE patient_support_tickets (
    id SERIAL PRIMARY KEY,
    ticket_number VARCHAR(20) NOT NULL,
    patient_id INTEGER NOT NULL REFERENCES patients(id),
    location_id INTEGER NOT NULL REFERENCES locations(id),
    subject VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    priority VARCHAR(20) DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high', 'urgent')),
    status VARCHAR(20) DEFAULT 'open' CHECK (status IN ('open', 'in_progress', 'resolved', 'closed')),
    assigned_to INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(ticket_number, location_id)
);

-- Patient queue
CREATE TABLE patient_queue (
    id SERIAL PRIMARY KEY,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    patient_id INTEGER NOT NULL REFERENCES patients(id),
    appointment_id INTEGER,
    queue_number INTEGER NOT NULL,
    queue_type VARCHAR(20) NOT NULL CHECK (queue_type IN ('consultation', 'lab', 'pharmacy', 'billing')),
    status VARCHAR(20) DEFAULT 'waiting' CHECK (status IN ('waiting', 'in_progress', 'completed', 'cancelled')),
    estimated_time TIMESTAMP,
    actual_time TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Patient transfers
CREATE TABLE patient_transfers (
    id SERIAL PRIMARY KEY,
    transfer_number VARCHAR(20) NOT NULL,
    patient_id INTEGER NOT NULL REFERENCES patients(id),
    from_location_id INTEGER NOT NULL REFERENCES locations(id),
    to_location_id INTEGER NOT NULL REFERENCES locations(id),
    from_bed_id INTEGER,
    to_bed_id INTEGER,
    transfer_date TIMESTAMP NOT NULL,
    reason TEXT,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'in_transit', 'completed', 'cancelled')),
    transferred_by INTEGER NOT NULL,
    received_by INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(transfer_number, from_location_id)
);

-- Indexes
CREATE INDEX idx_patients_location ON patients(location_id);
CREATE INDEX idx_patients_patient_unique_id ON patients(patient_unique_id);
CREATE INDEX idx_patient_portal_access_patient ON patient_portal_access(patient_id);
CREATE INDEX idx_patient_health_records_patient ON patient_health_records(patient_id);
CREATE INDEX idx_patient_support_tickets_location ON patient_support_tickets(location_id);
CREATE INDEX idx_patient_queue_location ON patient_queue(location_id);
CREATE INDEX idx_patient_transfers_from_location ON patient_transfers(from_location_id);