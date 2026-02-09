-- Laboratory Service Database Schema
-- Database: hims_laboratory

CREATE DATABASE hims_laboratory;
\c hims_laboratory;

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

-- Lab tests table
CREATE TABLE lab_tests (
    id SERIAL PRIMARY KEY,
    test_code VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    test_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    normal_range VARCHAR(100),
    unit VARCHAR(20),
    sample_type VARCHAR(50),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(test_code, location_id)
);

-- Lab orders table
CREATE TABLE lab_orders (
    id SERIAL PRIMARY KEY,
    order_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    patient_id INTEGER NOT NULL,
    doctor_id INTEGER NOT NULL,
    appointment_id INTEGER,
    status VARCHAR(20) DEFAULT 'ordered' CHECK (status IN ('ordered', 'collected', 'processing', 'completed', 'cancelled')),
    collection_date TIMESTAMP,
    report_date TIMESTAMP,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(order_number, location_id)
);

-- Lab order items table
CREATE TABLE lab_order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES lab_orders(id) ON DELETE CASCADE,
    test_id INTEGER NOT NULL REFERENCES lab_tests(id),
    result VARCHAR(255),
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'completed')),
    remarks TEXT
);

-- Lab equipment table
CREATE TABLE lab_equipment (
    id SERIAL PRIMARY KEY,
    equipment_code VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    name VARCHAR(100) NOT NULL,
    manufacturer VARCHAR(100),
    model VARCHAR(100),
    serial_number VARCHAR(100),
    purchase_date DATE,
    warranty_expiry DATE,
    maintenance_schedule VARCHAR(50),
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'maintenance', 'inactive')),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(equipment_code, location_id)
);

-- Lab reagents table
CREATE TABLE lab_reagents (
    id SERIAL PRIMARY KEY,
    reagent_code VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    name VARCHAR(100) NOT NULL,
    manufacturer VARCHAR(100),
    batch_number VARCHAR(50),
    expiry_date DATE,
    stock_quantity INTEGER NOT NULL,
    min_stock_level INTEGER DEFAULT 10,
    unit_price DECIMAL(10,2),
    storage_conditions TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(reagent_code, location_id)
);

-- Lab quality control table
CREATE TABLE lab_quality_control (
    id SERIAL PRIMARY KEY,
    qc_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    test_id INTEGER NOT NULL REFERENCES lab_tests(id),
    equipment_id INTEGER REFERENCES lab_equipment(id),
    control_type VARCHAR(20) NOT NULL CHECK (control_type IN ('normal', 'high', 'low')),
    expected_value VARCHAR(50),
    actual_value VARCHAR(50),
    variance DECIMAL(5,2),
    status VARCHAR(20) DEFAULT 'pass' CHECK (status IN ('pass', 'fail', 'review')),
    performed_by INTEGER NOT NULL,
    performed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    remarks TEXT,
    UNIQUE(qc_number, location_id)
);

-- Lab sample tracking table
CREATE TABLE lab_sample_tracking (
    id SERIAL PRIMARY KEY,
    sample_id VARCHAR(20) NOT NULL,
    order_id INTEGER NOT NULL REFERENCES lab_orders(id),
    location_id INTEGER NOT NULL REFERENCES locations(id),
    sample_type VARCHAR(50) NOT NULL,
    collection_time TIMESTAMP,
    received_time TIMESTAMP,
    processing_time TIMESTAMP,
    completion_time TIMESTAMP,
    status VARCHAR(20) DEFAULT 'collected' CHECK (status IN ('collected', 'received', 'processing', 'completed', 'rejected')),
    rejection_reason TEXT,
    handled_by INTEGER,
    UNIQUE(sample_id, location_id)
);

-- Indexes
CREATE INDEX idx_lab_tests_location ON lab_tests(location_id);
CREATE INDEX idx_lab_orders_location ON lab_orders(location_id);
CREATE INDEX idx_lab_orders_patient_id ON lab_orders(patient_id);
CREATE INDEX idx_lab_orders_doctor_id ON lab_orders(doctor_id);
CREATE INDEX idx_lab_equipment_location ON lab_equipment(location_id);
CREATE INDEX idx_lab_reagents_location ON lab_reagents(location_id);
CREATE INDEX idx_lab_quality_control_location ON lab_quality_control(location_id);
CREATE INDEX idx_lab_sample_tracking_location ON lab_sample_tracking(location_id);
CREATE INDEX idx_lab_sample_tracking_order ON lab_sample_tracking(order_id);