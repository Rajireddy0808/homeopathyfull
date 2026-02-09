-- Front Office Service Database Schema
-- Database: hims_front_office

CREATE DATABASE hims_front_office;
\c hims_front_office;

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

-- Estimates
CREATE TABLE estimates (
    id SERIAL PRIMARY KEY,
    estimate_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    patient_id INTEGER,
    patient_name VARCHAR(100),
    patient_phone VARCHAR(15),
    total_amount DECIMAL(10,2) NOT NULL,
    discount_amount DECIMAL(10,2) DEFAULT 0,
    net_amount DECIMAL(10,2) NOT NULL,
    valid_until DATE,
    status VARCHAR(20) DEFAULT 'draft' CHECK (status IN ('draft', 'sent', 'accepted', 'rejected', 'expired')),
    created_by INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(estimate_number, location_id)
);

-- Estimate items
CREATE TABLE estimate_items (
    id SERIAL PRIMARY KEY,
    estimate_id INTEGER NOT NULL REFERENCES estimates(id) ON DELETE CASCADE,
    item_name VARCHAR(100) NOT NULL,
    item_code VARCHAR(50),
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    category VARCHAR(50)
);

-- Queue tokens
CREATE TABLE queue_tokens (
    id SERIAL PRIMARY KEY,
    token_number VARCHAR(20) NOT NULL,
    patient_id INTEGER NOT NULL,
    appointment_id INTEGER,
    department VARCHAR(100),
    priority_level INTEGER DEFAULT 1,
    estimated_wait_time INTEGER,
    status VARCHAR(20) DEFAULT 'waiting' CHECK (status IN ('waiting', 'called', 'completed', 'cancelled')),
    location_id INTEGER NOT NULL REFERENCES locations(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    called_at TIMESTAMP,
    completed_at TIMESTAMP
);

-- Reception logs
CREATE TABLE reception_logs (
    id SERIAL PRIMARY KEY,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    patient_id INTEGER NOT NULL,
    receptionist_id INTEGER NOT NULL,
    action_type VARCHAR(50) NOT NULL CHECK (action_type IN ('check_in', 'appointment_scheduled', 'estimate_created', 'bill_generated', 'queue_token_issued')),
    description TEXT,
    reference_id INTEGER,
    reference_type VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Walk-in registrations
CREATE TABLE walk_in_registrations (
    id SERIAL PRIMARY KEY,
    registration_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    email VARCHAR(100),
    age INTEGER,
    gender VARCHAR(10) CHECK (gender IN ('male', 'female', 'other')),
    address TEXT,
    emergency_contact VARCHAR(15),
    reason_for_visit TEXT,
    registered_by INTEGER NOT NULL,
    status VARCHAR(20) DEFAULT 'registered' CHECK (status IN ('registered', 'converted_to_patient', 'completed')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(registration_number, location_id)
);

-- Visitor logs
CREATE TABLE visitor_logs (
    id SERIAL PRIMARY KEY,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    visitor_name VARCHAR(100) NOT NULL,
    visitor_phone VARCHAR(15),
    purpose VARCHAR(100) NOT NULL,
    person_to_meet VARCHAR(100),
    department VARCHAR(50),
    check_in_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    check_out_time TIMESTAMP,
    id_proof_type VARCHAR(20),
    id_proof_number VARCHAR(50),
    logged_by INTEGER NOT NULL
);

-- Feedback forms
CREATE TABLE feedback_forms (
    id SERIAL PRIMARY KEY,
    feedback_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    patient_id INTEGER,
    patient_name VARCHAR(100),
    service_type VARCHAR(50) NOT NULL,
    overall_rating INTEGER CHECK (overall_rating BETWEEN 1 AND 5),
    staff_behavior_rating INTEGER CHECK (staff_behavior_rating BETWEEN 1 AND 5),
    facility_rating INTEGER CHECK (facility_rating BETWEEN 1 AND 5),
    waiting_time_rating INTEGER CHECK (waiting_time_rating BETWEEN 1 AND 5),
    comments TEXT,
    suggestions TEXT,
    would_recommend BOOLEAN,
    collected_by INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(feedback_number, location_id)
);

-- Indexes
CREATE INDEX idx_estimates_location ON estimates(location_id);
CREATE INDEX idx_estimates_patient ON estimates(patient_id);
CREATE INDEX idx_estimate_items_estimate ON estimate_items(estimate_id);
CREATE INDEX idx_queue_tokens_location ON queue_tokens(location_id);
CREATE INDEX idx_queue_tokens_patient ON queue_tokens(patient_id);
CREATE INDEX idx_queue_tokens_status ON queue_tokens(status);
CREATE INDEX idx_reception_logs_location ON reception_logs(location_id);
CREATE INDEX idx_reception_logs_patient ON reception_logs(patient_id);
CREATE INDEX idx_walk_in_registrations_location ON walk_in_registrations(location_id);
CREATE INDEX idx_visitor_logs_location ON visitor_logs(location_id);
CREATE INDEX idx_feedback_forms_location ON feedback_forms(location_id);