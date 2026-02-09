-- Pharmacy Service Database Schema
-- Database: hims_pharmacy

CREATE DATABASE hims_pharmacy;
\c hims_pharmacy;

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

-- Medicines table
CREATE TABLE medicines (
    id SERIAL PRIMARY KEY,
    medicine_code VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    name VARCHAR(100) NOT NULL,
    generic_name VARCHAR(100) NOT NULL,
    manufacturer VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    stock_quantity INTEGER NOT NULL,
    min_stock_level INTEGER DEFAULT 10,
    expiry_date DATE,
    batch_number VARCHAR(50) NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(medicine_code, location_id)
);

-- Pharmacy sales table
CREATE TABLE pharmacy_sales (
    id SERIAL PRIMARY KEY,
    sale_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    patient_id INTEGER,
    prescription_id INTEGER,
    total_amount DECIMAL(10,2) NOT NULL,
    discount_amount DECIMAL(10,2) DEFAULT 0,
    net_amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(20) NOT NULL,
    sold_by INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(sale_number, location_id)
);

-- Pharmacy sale items table
CREATE TABLE pharmacy_sale_items (
    id SERIAL PRIMARY KEY,
    sale_id INTEGER NOT NULL REFERENCES pharmacy_sales(id) ON DELETE CASCADE,
    medicine_id INTEGER NOT NULL REFERENCES medicines(id),
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL
);

-- Central pharmacy items
CREATE TABLE central_pharmacy_items (
    id SERIAL PRIMARY KEY,
    item_code VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    name VARCHAR(100) NOT NULL,
    generic_name VARCHAR(100),
    manufacturer VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    stock_quantity INTEGER NOT NULL,
    min_stock_level INTEGER DEFAULT 10,
    max_stock_level INTEGER DEFAULT 1000,
    expiry_date DATE,
    batch_number VARCHAR(50) NOT NULL,
    rack_location VARCHAR(20),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(item_code, location_id)
);

-- Pharmacy indents
CREATE TABLE pharmacy_indents (
    id SERIAL PRIMARY KEY,
    indent_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    requested_by INTEGER NOT NULL,
    approved_by INTEGER,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected', 'ordered')),
    total_amount DECIMAL(10,2),
    request_date DATE NOT NULL,
    required_date DATE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(indent_number, location_id)
);

-- Pharmacy indent items
CREATE TABLE pharmacy_indent_items (
    id SERIAL PRIMARY KEY,
    indent_id INTEGER NOT NULL REFERENCES pharmacy_indents(id) ON DELETE CASCADE,
    item_id INTEGER NOT NULL REFERENCES central_pharmacy_items(id),
    requested_quantity INTEGER NOT NULL,
    approved_quantity INTEGER DEFAULT 0,
    unit_price DECIMAL(10,2),
    total_price DECIMAL(10,2)
);

-- Medicine interactions table
CREATE TABLE medicine_interactions (
    id SERIAL PRIMARY KEY,
    medicine_a_id INTEGER NOT NULL REFERENCES medicines(id),
    medicine_b_id INTEGER NOT NULL REFERENCES medicines(id),
    interaction_type VARCHAR(20) NOT NULL CHECK (interaction_type IN ('major', 'moderate', 'minor')),
    description TEXT NOT NULL,
    recommendation TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Medicine allergies table
CREATE TABLE medicine_allergies (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER NOT NULL,
    medicine_id INTEGER NOT NULL REFERENCES medicines(id),
    allergy_type VARCHAR(50) NOT NULL,
    severity VARCHAR(20) CHECK (severity IN ('mild', 'moderate', 'severe')),
    symptoms TEXT,
    reported_date DATE NOT NULL,
    reported_by INTEGER NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Stock movements table
CREATE TABLE stock_movements (
    id SERIAL PRIMARY KEY,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    medicine_id INTEGER NOT NULL REFERENCES medicines(id),
    movement_type VARCHAR(20) NOT NULL CHECK (movement_type IN ('in', 'out', 'adjustment', 'expired', 'damaged')),
    quantity INTEGER NOT NULL,
    reference_type VARCHAR(20) CHECK (reference_type IN ('sale', 'purchase', 'adjustment', 'transfer')),
    reference_id INTEGER,
    batch_number VARCHAR(50),
    expiry_date DATE,
    unit_cost DECIMAL(10,2),
    total_cost DECIMAL(10,2),
    moved_by INTEGER NOT NULL,
    movement_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT
);

-- Indexes
CREATE INDEX idx_medicines_location ON medicines(location_id);
CREATE INDEX idx_pharmacy_sales_location ON pharmacy_sales(location_id);
CREATE INDEX idx_pharmacy_sales_patient ON pharmacy_sales(patient_id);
CREATE INDEX idx_central_pharmacy_items_location ON central_pharmacy_items(location_id);
CREATE INDEX idx_pharmacy_indents_location ON pharmacy_indents(location_id);
CREATE INDEX idx_medicine_interactions_medicine_a ON medicine_interactions(medicine_a_id);
CREATE INDEX idx_medicine_interactions_medicine_b ON medicine_interactions(medicine_b_id);
CREATE INDEX idx_medicine_allergies_patient ON medicine_allergies(patient_id);
CREATE INDEX idx_medicine_allergies_medicine ON medicine_allergies(medicine_id);
CREATE INDEX idx_stock_movements_location ON stock_movements(location_id);
CREATE INDEX idx_stock_movements_medicine ON stock_movements(medicine_id);