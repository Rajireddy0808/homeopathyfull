-- Appointments Service Database Schema
-- Database: hims_appointments

CREATE DATABASE hims_appointments;
\c hims_appointments;

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

-- Departments
CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(10),
    location_id INTEGER NOT NULL REFERENCES locations(id),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Appointments table
CREATE TABLE appointments (
    id SERIAL PRIMARY KEY,
    appointment_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    patient_id INTEGER NOT NULL,
    doctor_id INTEGER NOT NULL,
    appointment_date TIMESTAMP NOT NULL,
    type VARCHAR(20) NOT NULL CHECK (type IN ('consultation', 'follow_up', 'emergency', 'routine_checkup')),
    status VARCHAR(20) DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'confirmed', 'in_progress', 'completed', 'cancelled', 'no_show')),
    reason VARCHAR(255),
    notes TEXT,
    consultation_fee DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(appointment_number, location_id)
);

-- Doctor schedules table
CREATE TABLE doctor_schedules (
    id SERIAL PRIMARY KEY,
    doctor_id INTEGER NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    day_of_week INTEGER NOT NULL CHECK (day_of_week BETWEEN 0 AND 6),
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Doctor rounds table
CREATE TABLE doctor_rounds (
    id SERIAL PRIMARY KEY,
    round_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    doctor_id INTEGER NOT NULL,
    round_date DATE NOT NULL,
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(round_number, location_id)
);

-- Doctor round patients table
CREATE TABLE doctor_round_patients (
    id SERIAL PRIMARY KEY,
    round_id INTEGER NOT NULL REFERENCES doctor_rounds(id) ON DELETE CASCADE,
    patient_id INTEGER NOT NULL,
    admission_id INTEGER,
    visit_order INTEGER,
    notes TEXT,
    visited_at TIMESTAMP
);

-- Queue tokens
CREATE TABLE queue_tokens (
    id SERIAL PRIMARY KEY,
    token_number VARCHAR(20) NOT NULL,
    patient_id INTEGER NOT NULL,
    appointment_id INTEGER REFERENCES appointments(id),
    department VARCHAR(100),
    priority_level INTEGER DEFAULT 1,
    estimated_wait_time INTEGER,
    status VARCHAR(20) DEFAULT 'waiting' CHECK (status IN ('waiting', 'called', 'completed', 'cancelled')),
    location_id INTEGER NOT NULL REFERENCES locations(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    called_at TIMESTAMP,
    completed_at TIMESTAMP
);

-- Shifts table
CREATE TABLE shifts (
    id SERIAL PRIMARY KEY,
    shift_name VARCHAR(50) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- User shifts
CREATE TABLE user_shifts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    shift_id INTEGER NOT NULL REFERENCES shifts(id),
    shift_date DATE NOT NULL,
    check_in_time TIMESTAMP,
    check_out_time TIMESTAMP,
    status VARCHAR(20) DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'checked_in', 'checked_out', 'absent')),
    notes TEXT
);

-- Indexes
CREATE INDEX idx_appointments_location ON appointments(location_id);
CREATE INDEX idx_appointments_patient_id ON appointments(patient_id);
CREATE INDEX idx_appointments_doctor_id ON appointments(doctor_id);
CREATE INDEX idx_appointments_date ON appointments(appointment_date);
CREATE INDEX idx_doctor_schedules_doctor ON doctor_schedules(doctor_id);
CREATE INDEX idx_doctor_schedules_location ON doctor_schedules(location_id);
CREATE INDEX idx_doctor_rounds_location ON doctor_rounds(location_id);
CREATE INDEX idx_doctor_rounds_doctor ON doctor_rounds(doctor_id);
CREATE INDEX idx_queue_tokens_location ON queue_tokens(location_id);
CREATE INDEX idx_queue_tokens_patient ON queue_tokens(patient_id);
CREATE INDEX idx_shifts_location ON shifts(location_id);
CREATE INDEX idx_user_shifts_user ON user_shifts(user_id);