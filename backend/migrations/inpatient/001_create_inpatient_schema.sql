-- Inpatient Service Database Schema
-- Database: hims_inpatient

CREATE DATABASE hims_inpatient;
\c hims_inpatient;

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

-- Beds table
CREATE TABLE beds (
    id SERIAL PRIMARY KEY,
    bed_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    ward VARCHAR(50) NOT NULL,
    bed_type VARCHAR(20) NOT NULL CHECK (bed_type IN ('general', 'private', 'icu', 'emergency')),
    status VARCHAR(20) DEFAULT 'available' CHECK (status IN ('available', 'occupied', 'maintenance', 'reserved')),
    price_per_day DECIMAL(10,2) NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(bed_number, location_id)
);

-- Advance collections
CREATE TABLE advance_collections (
    id SERIAL PRIMARY KEY,
    receipt_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    patient_id INTEGER NOT NULL,
    admission_id INTEGER,
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(20) NOT NULL CHECK (payment_method IN ('cash', 'card', 'upi', 'bank_transfer')),
    collected_by INTEGER NOT NULL,
    purpose TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(receipt_number, location_id)
);

-- Inpatient census
CREATE TABLE inpatient_census (
    id SERIAL PRIMARY KEY,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    census_date DATE NOT NULL,
    total_beds INTEGER NOT NULL,
    occupied_beds INTEGER NOT NULL,
    available_beds INTEGER NOT NULL,
    admissions_today INTEGER DEFAULT 0,
    discharges_today INTEGER DEFAULT 0,
    transfers_in INTEGER DEFAULT 0,
    transfers_out INTEGER DEFAULT 0,
    occupancy_rate DECIMAL(5,2),
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(location_id, census_date)
);

-- Ward management table
CREATE TABLE wards (
    id SERIAL PRIMARY KEY,
    ward_code VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    name VARCHAR(100) NOT NULL,
    ward_type VARCHAR(20) NOT NULL CHECK (ward_type IN ('general', 'private', 'icu', 'emergency', 'maternity', 'pediatric')),
    total_beds INTEGER NOT NULL,
    nurse_in_charge INTEGER,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(ward_code, location_id)
);

-- Bed reservations table
CREATE TABLE bed_reservations (
    id SERIAL PRIMARY KEY,
    reservation_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    bed_id INTEGER NOT NULL REFERENCES beds(id),
    patient_id INTEGER NOT NULL,
    reserved_by INTEGER NOT NULL,
    reservation_date TIMESTAMP NOT NULL,
    expected_admission_date TIMESTAMP NOT NULL,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'confirmed', 'cancelled', 'expired')),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(reservation_number, location_id)
);

-- Discharge planning table
CREATE TABLE discharge_planning (
    id SERIAL PRIMARY KEY,
    admission_id INTEGER NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    patient_id INTEGER NOT NULL,
    planned_discharge_date DATE,
    discharge_type VARCHAR(20) CHECK (discharge_type IN ('home', 'transfer', 'ama', 'death')),
    discharge_summary TEXT,
    follow_up_instructions TEXT,
    medications_prescribed TEXT,
    planned_by INTEGER NOT NULL,
    status VARCHAR(20) DEFAULT 'planning' CHECK (status IN ('planning', 'ready', 'completed', 'cancelled')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Nursing notes table
CREATE TABLE nursing_notes (
    id SERIAL PRIMARY KEY,
    admission_id INTEGER NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    patient_id INTEGER NOT NULL,
    note_type VARCHAR(20) NOT NULL CHECK (note_type IN ('assessment', 'medication', 'vital_signs', 'general', 'incident')),
    note_text TEXT NOT NULL,
    recorded_by INTEGER NOT NULL,
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    shift VARCHAR(20) CHECK (shift IN ('morning', 'evening', 'night'))
);

-- Patient care plans table
CREATE TABLE patient_care_plans (
    id SERIAL PRIMARY KEY,
    admission_id INTEGER NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    patient_id INTEGER NOT NULL,
    care_plan_type VARCHAR(50) NOT NULL,
    description TEXT NOT NULL,
    goals TEXT,
    interventions TEXT,
    expected_outcome TEXT,
    created_by INTEGER NOT NULL,
    assigned_to INTEGER,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'completed', 'discontinued')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bed maintenance log table
CREATE TABLE bed_maintenance_log (
    id SERIAL PRIMARY KEY,
    bed_id INTEGER NOT NULL REFERENCES beds(id),
    location_id INTEGER NOT NULL REFERENCES locations(id),
    maintenance_type VARCHAR(50) NOT NULL CHECK (maintenance_type IN ('cleaning', 'repair', 'inspection', 'replacement')),
    description TEXT NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP,
    performed_by INTEGER NOT NULL,
    status VARCHAR(20) DEFAULT 'in_progress' CHECK (status IN ('scheduled', 'in_progress', 'completed', 'cancelled')),
    cost DECIMAL(10,2),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX idx_beds_location ON beds(location_id);
CREATE INDEX idx_beds_status ON beds(status);
CREATE INDEX idx_advance_collections_location ON advance_collections(location_id);
CREATE INDEX idx_advance_collections_patient ON advance_collections(patient_id);
CREATE INDEX idx_inpatient_census_location ON inpatient_census(location_id);
CREATE INDEX idx_inpatient_census_date ON inpatient_census(census_date);
CREATE INDEX idx_wards_location ON wards(location_id);
CREATE INDEX idx_bed_reservations_location ON bed_reservations(location_id);
CREATE INDEX idx_bed_reservations_bed ON bed_reservations(bed_id);
CREATE INDEX idx_discharge_planning_location ON discharge_planning(location_id);
CREATE INDEX idx_discharge_planning_patient ON discharge_planning(patient_id);
CREATE INDEX idx_nursing_notes_admission ON nursing_notes(admission_id);
CREATE INDEX idx_nursing_notes_patient ON nursing_notes(patient_id);
CREATE INDEX idx_patient_care_plans_admission ON patient_care_plans(admission_id);
CREATE INDEX idx_bed_maintenance_log_bed ON bed_maintenance_log(bed_id);