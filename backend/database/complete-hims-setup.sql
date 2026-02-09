-- COMPLETE HIMS Database Setup - ALL Tables and Sample Data
-- Run this single file to create all tables and insert all sample data

-- Create database
CREATE DATABASE hims_db;

-- Use the database
\c hims_db;

-- Locations table
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

-- Users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('admin', 'doctor', 'nurse', 'pharmacist', 'lab_technician', 'front_office', 'telecaller', 'billing', 'material_manager')),
    location_id INTEGER NOT NULL REFERENCES locations(id),
    is_active BOOLEAN DEFAULT true,
    phone VARCHAR(15),
    department VARCHAR(50),
    specialization VARCHAR(100),
    license_number VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Patients table
CREATE TABLE patients (
    id SERIAL PRIMARY KEY,
    patient_id VARCHAR(20) NOT NULL,
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
    UNIQUE(patient_id, location_id)
);

-- Appointments table
CREATE TABLE appointments (
    id SERIAL PRIMARY KEY,
    appointment_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    patient_id INTEGER NOT NULL REFERENCES patients(id),
    doctor_id INTEGER NOT NULL REFERENCES users(id),
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

-- Vitals table
CREATE TABLE vitals (
    id SERIAL PRIMARY KEY,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    patient_id INTEGER NOT NULL REFERENCES patients(id),
    appointment_id INTEGER REFERENCES appointments(id),
    recorded_by INTEGER NOT NULL REFERENCES users(id),
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

-- Bills table
CREATE TABLE bills (
    id SERIAL PRIMARY KEY,
    bill_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    patient_id INTEGER NOT NULL REFERENCES patients(id),
    appointment_id INTEGER REFERENCES appointments(id),
    total_amount DECIMAL(10,2) NOT NULL,
    discount_amount DECIMAL(10,2) DEFAULT 0,
    tax_amount DECIMAL(10,2) DEFAULT 0,
    net_amount DECIMAL(10,2) NOT NULL,
    paid_amount DECIMAL(10,2) DEFAULT 0,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('draft', 'pending', 'paid', 'partially_paid', 'cancelled')),
    payment_method VARCHAR(20) CHECK (payment_method IN ('cash', 'card', 'upi', 'bank_transfer', 'insurance')),
    insurance_claim_id VARCHAR(50),
    created_by INTEGER NOT NULL REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(bill_number, location_id)
);

-- Bill items table
CREATE TABLE bill_items (
    id SERIAL PRIMARY KEY,
    bill_id INTEGER NOT NULL REFERENCES bills(id) ON DELETE CASCADE,
    item_name VARCHAR(100) NOT NULL,
    item_code VARCHAR(50) NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    category VARCHAR(50)
);

-- Service master table
CREATE TABLE services (
    id SERIAL PRIMARY KEY,
    service_code VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(service_code, location_id)
);

-- Package master table
CREATE TABLE packages (
    id SERIAL PRIMARY KEY,
    package_code VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    total_price DECIMAL(10,2) NOT NULL,
    discounted_price DECIMAL(10,2),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(package_code, location_id)
);

-- Package services mapping
CREATE TABLE package_services (
    id SERIAL PRIMARY KEY,
    package_id INTEGER NOT NULL REFERENCES packages(id) ON DELETE CASCADE,
    service_id INTEGER NOT NULL REFERENCES services(id),
    quantity INTEGER DEFAULT 1
);

-- Discount master table
CREATE TABLE discounts (
    id SERIAL PRIMARY KEY,
    discount_code VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    name VARCHAR(100) NOT NULL,
    type VARCHAR(20) NOT NULL CHECK (type IN ('percentage', 'fixed')),
    value DECIMAL(10,2) NOT NULL,
    min_amount DECIMAL(10,2),
    max_discount DECIMAL(10,2),
    valid_from DATE,
    valid_to DATE,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(discount_code, location_id)
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

-- Prescriptions table
CREATE TABLE prescriptions (
    id SERIAL PRIMARY KEY,
    prescription_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    patient_id INTEGER NOT NULL REFERENCES patients(id),
    doctor_id INTEGER NOT NULL REFERENCES users(id),
    appointment_id INTEGER REFERENCES appointments(id),
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
    medicine_id INTEGER NOT NULL REFERENCES medicines(id),
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
    doctor_id INTEGER NOT NULL REFERENCES users(id),
    diagnosis VARCHAR(255),
    template_data JSONB NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Pharmacy sales table
CREATE TABLE pharmacy_sales (
    id SERIAL PRIMARY KEY,
    sale_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    patient_id INTEGER REFERENCES patients(id),
    prescription_id INTEGER REFERENCES prescriptions(id),
    total_amount DECIMAL(10,2) NOT NULL,
    discount_amount DECIMAL(10,2) DEFAULT 0,
    net_amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(20) NOT NULL,
    sold_by INTEGER NOT NULL REFERENCES users(id),
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
    patient_id INTEGER NOT NULL REFERENCES patients(id),
    doctor_id INTEGER NOT NULL REFERENCES users(id),
    appointment_id INTEGER REFERENCES appointments(id),
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

-- Admissions table
CREATE TABLE admissions (
    id SERIAL PRIMARY KEY,
    admission_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    patient_id INTEGER NOT NULL REFERENCES patients(id),
    bed_id INTEGER NOT NULL REFERENCES beds(id),
    doctor_id INTEGER NOT NULL REFERENCES users(id),
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
    from_bed_id INTEGER NOT NULL REFERENCES beds(id),
    to_bed_id INTEGER NOT NULL REFERENCES beds(id),
    transfer_date TIMESTAMP NOT NULL,
    reason TEXT,
    transferred_by INTEGER NOT NULL REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insurance companies table
CREATE TABLE insurance_companies (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(20) UNIQUE NOT NULL,
    contact_person VARCHAR(100),
    phone VARCHAR(15),
    email VARCHAR(100),
    address TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- TPA companies table
CREATE TABLE tpa_companies (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(20) UNIQUE NOT NULL,
    contact_person VARCHAR(100),
    phone VARCHAR(15),
    email VARCHAR(100),
    address TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insurance rates table
CREATE TABLE insurance_rates (
    id SERIAL PRIMARY KEY,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    insurance_company_id INTEGER NOT NULL REFERENCES insurance_companies(id),
    service_id INTEGER REFERENCES services(id),
    package_id INTEGER REFERENCES packages(id),
    coverage_percentage DECIMAL(5,2) NOT NULL,
    max_coverage_amount DECIMAL(10,2),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Pre-authorization table
CREATE TABLE pre_authorizations (
    id SERIAL PRIMARY KEY,
    auth_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    patient_id INTEGER NOT NULL REFERENCES patients(id),
    insurance_company_id INTEGER NOT NULL REFERENCES insurance_companies(id),
    requested_amount DECIMAL(10,2) NOT NULL,
    approved_amount DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected', 'expired')),
    valid_from DATE,
    valid_to DATE,
    diagnosis TEXT,
    treatment_plan TEXT,
    created_by INTEGER NOT NULL REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(auth_number, location_id)
);

-- Insurance claims table
CREATE TABLE insurance_claims (
    id SERIAL PRIMARY KEY,
    claim_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    patient_id INTEGER NOT NULL REFERENCES patients(id),
    insurance_company_id INTEGER NOT NULL REFERENCES insurance_companies(id),
    bill_id INTEGER REFERENCES bills(id),
    pre_auth_id INTEGER REFERENCES pre_authorizations(id),
    claim_amount DECIMAL(10,2) NOT NULL,
    approved_amount DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'submitted' CHECK (status IN ('submitted', 'under_review', 'approved', 'rejected', 'paid')),
    submission_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    approval_date TIMESTAMP,
    remarks TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(claim_number, location_id)
);

-- Vendors table
CREATE TABLE vendors (
    id SERIAL PRIMARY KEY,
    vendor_code VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    name VARCHAR(100) NOT NULL,
    contact_person VARCHAR(100),
    phone VARCHAR(15),
    email VARCHAR(100),
    address TEXT,
    gst_number VARCHAR(20),
    pan_number VARCHAR(20),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(vendor_code, location_id)
);

-- Items master table
CREATE TABLE items (
    id SERIAL PRIMARY KEY,
    item_code VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    unit VARCHAR(20) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    stock_quantity INTEGER NOT NULL,
    min_stock_level INTEGER DEFAULT 10,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(item_code, location_id)
);

-- Purchase orders table
CREATE TABLE purchase_orders (
    id SERIAL PRIMARY KEY,
    po_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    vendor_id INTEGER NOT NULL REFERENCES vendors(id),
    total_amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'draft' CHECK (status IN ('draft', 'sent', 'approved', 'received', 'cancelled')),
    order_date DATE NOT NULL,
    expected_delivery_date DATE,
    created_by INTEGER NOT NULL REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(po_number, location_id)
);

-- Purchase order items table
CREATE TABLE purchase_order_items (
    id SERIAL PRIMARY KEY,
    po_id INTEGER NOT NULL REFERENCES purchase_orders(id) ON DELETE CASCADE,
    item_id INTEGER NOT NULL REFERENCES items(id),
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL
);

-- GRN table
CREATE TABLE grn (
    id SERIAL PRIMARY KEY,
    grn_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    po_id INTEGER NOT NULL REFERENCES purchase_orders(id),
    vendor_id INTEGER NOT NULL REFERENCES vendors(id),
    invoice_number VARCHAR(50),
    invoice_date DATE,
    total_amount DECIMAL(10,2) NOT NULL,
    received_by INTEGER NOT NULL REFERENCES users(id),
    received_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(grn_number, location_id)
);

-- GRN items table
CREATE TABLE grn_items (
    id SERIAL PRIMARY KEY,
    grn_id INTEGER NOT NULL REFERENCES grn(id) ON DELETE CASCADE,
    item_id INTEGER NOT NULL REFERENCES items(id),
    ordered_quantity INTEGER NOT NULL,
    received_quantity INTEGER NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL
);

-- Stock adjustments table
CREATE TABLE stock_adjustments (
    id SERIAL PRIMARY KEY,
    adjustment_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    item_id INTEGER NOT NULL REFERENCES items(id),
    adjustment_type VARCHAR(20) NOT NULL CHECK (adjustment_type IN ('increase', 'decrease')),
    quantity INTEGER NOT NULL,
    reason TEXT,
    adjusted_by INTEGER NOT NULL REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(adjustment_number, location_id)
);

-- Stock transfers table
CREATE TABLE stock_transfers (
    id SERIAL PRIMARY KEY,
    transfer_number VARCHAR(20) NOT NULL,
    from_location_id INTEGER NOT NULL REFERENCES locations(id),
    to_location_id INTEGER NOT NULL REFERENCES locations(id),
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'in_transit', 'received', 'cancelled')),
    transfer_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    received_date TIMESTAMP,
    transferred_by INTEGER NOT NULL REFERENCES users(id),
    received_by INTEGER REFERENCES users(id),
    UNIQUE(transfer_number, from_location_id)
);

-- Stock transfer items table
CREATE TABLE stock_transfer_items (
    id SERIAL PRIMARY KEY,
    transfer_id INTEGER NOT NULL REFERENCES stock_transfers(id) ON DELETE CASCADE,
    item_id INTEGER NOT NULL REFERENCES items(id),
    quantity INTEGER NOT NULL,
    received_quantity INTEGER DEFAULT 0
);

-- Doctor schedules table
CREATE TABLE doctor_schedules (
    id SERIAL PRIMARY KEY,
    doctor_id INTEGER NOT NULL REFERENCES users(id),
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
    doctor_id INTEGER NOT NULL REFERENCES users(id),
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
    patient_id INTEGER NOT NULL REFERENCES patients(id),
    admission_id INTEGER REFERENCES admissions(id),
    visit_order INTEGER,
    notes TEXT,
    visited_at TIMESTAMP
);

-- Communications table
CREATE TABLE communications (
    id SERIAL PRIMARY KEY,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    from_user_id INTEGER NOT NULL REFERENCES users(id),
    to_user_id INTEGER REFERENCES users(id),
    patient_id INTEGER REFERENCES patients(id),
    subject VARCHAR(255),
    message TEXT NOT NULL,
    priority VARCHAR(20) DEFAULT 'normal' CHECK (priority IN ('low', 'normal', 'high', 'urgent')),
    is_read BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Telecaller campaigns table
CREATE TABLE telecaller_campaigns (
    id SERIAL PRIMARY KEY,
    campaign_name VARCHAR(100) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    description TEXT,
    start_date DATE NOT NULL,
    end_date DATE,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'paused', 'completed', 'cancelled')),
    created_by INTEGER NOT NULL REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Telecaller follow-ups table
CREATE TABLE telecaller_followups (
    id SERIAL PRIMARY KEY,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    patient_id INTEGER NOT NULL REFERENCES patients(id),
    telecaller_id INTEGER NOT NULL REFERENCES users(id),
    campaign_id INTEGER REFERENCES telecaller_campaigns(id),
    follow_up_type VARCHAR(20) NOT NULL CHECK (follow_up_type IN ('appointment_reminder', 'payment_due', 'health_checkup', 'feedback', 'general')),
    scheduled_date TIMESTAMP NOT NULL,
    completed_date TIMESTAMP,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'failed', 'rescheduled')),
    notes TEXT,
    outcome TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Patient queue table
CREATE TABLE patient_queue (
    id SERIAL PRIMARY KEY,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    patient_id INTEGER NOT NULL REFERENCES patients(id),
    appointment_id INTEGER REFERENCES appointments(id),
    queue_number INTEGER NOT NULL,
    queue_type VARCHAR(20) NOT NULL CHECK (queue_type IN ('consultation', 'lab', 'pharmacy', 'billing')),
    status VARCHAR(20) DEFAULT 'waiting' CHECK (status IN ('waiting', 'in_progress', 'completed', 'cancelled')),
    estimated_time TIMESTAMP,
    actual_time TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- System settings table
CREATE TABLE system_settings (
    id SERIAL PRIMARY KEY,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    setting_key VARCHAR(100) NOT NULL,
    setting_value TEXT NOT NULL,
    description TEXT,
    updated_by INTEGER NOT NULL REFERENCES users(id),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(location_id, setting_key)
);-- Additional tables for complete frontend coverage

-- Central Pharmacy specific tables
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

-- Pharmacy Indents
CREATE TABLE pharmacy_indents (
    id SERIAL PRIMARY KEY,
    indent_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    requested_by INTEGER NOT NULL REFERENCES users(id),
    approved_by INTEGER REFERENCES users(id),
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected', 'ordered')),
    total_amount DECIMAL(10,2),
    request_date DATE NOT NULL,
    required_date DATE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(indent_number, location_id)
);

CREATE TABLE pharmacy_indent_items (
    id SERIAL PRIMARY KEY,
    indent_id INTEGER NOT NULL REFERENCES pharmacy_indents(id) ON DELETE CASCADE,
    item_id INTEGER NOT NULL REFERENCES central_pharmacy_items(id),
    requested_quantity INTEGER NOT NULL,
    approved_quantity INTEGER DEFAULT 0,
    unit_price DECIMAL(10,2),
    total_price DECIMAL(10,2)
);

-- RFQ tables
CREATE TABLE rfq (
    id SERIAL PRIMARY KEY,
    rfq_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    title VARCHAR(200) NOT NULL,
    description TEXT,
    issue_date DATE NOT NULL,
    submission_deadline DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'issued' CHECK (status IN ('draft', 'issued', 'closed', 'cancelled')),
    created_by INTEGER NOT NULL REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(rfq_number, location_id)
);

CREATE TABLE rfq_items (
    id SERIAL PRIMARY KEY,
    rfq_id INTEGER NOT NULL REFERENCES rfq(id) ON DELETE CASCADE,
    item_description TEXT NOT NULL,
    quantity INTEGER NOT NULL,
    unit VARCHAR(20) NOT NULL,
    specifications TEXT
);

CREATE TABLE rfq_responses (
    id SERIAL PRIMARY KEY,
    rfq_id INTEGER NOT NULL REFERENCES rfq(id),
    vendor_id INTEGER NOT NULL REFERENCES vendors(id),
    total_amount DECIMAL(10,2) NOT NULL,
    submission_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    validity_days INTEGER DEFAULT 30,
    terms_conditions TEXT,
    status VARCHAR(20) DEFAULT 'submitted' CHECK (status IN ('submitted', 'under_review', 'accepted', 'rejected'))
);

CREATE TABLE rfq_response_items (
    id SERIAL PRIMARY KEY,
    response_id INTEGER NOT NULL REFERENCES rfq_responses(id) ON DELETE CASCADE,
    rfq_item_id INTEGER NOT NULL REFERENCES rfq_items(id),
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    delivery_days INTEGER,
    brand VARCHAR(100)
);

-- Contracts table
CREATE TABLE contracts (
    id SERIAL PRIMARY KEY,
    contract_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    vendor_id INTEGER NOT NULL REFERENCES vendors(id),
    title VARCHAR(200) NOT NULL,
    description TEXT,
    contract_value DECIMAL(12,2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('draft', 'active', 'expired', 'terminated')),
    terms_conditions TEXT,
    created_by INTEGER NOT NULL REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(contract_number, location_id)
);

-- Material schemes table
CREATE TABLE material_schemes (
    id SERIAL PRIMARY KEY,
    scheme_code VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    scheme_type VARCHAR(20) NOT NULL CHECK (scheme_type IN ('discount', 'free_goods', 'cashback')),
    value DECIMAL(10,2) NOT NULL,
    min_order_value DECIMAL(10,2),
    valid_from DATE NOT NULL,
    valid_to DATE NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(scheme_code, location_id)
);

-- AI Insights table
CREATE TABLE ai_insights (
    id SERIAL PRIMARY KEY,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    insight_type VARCHAR(50) NOT NULL CHECK (insight_type IN ('inventory_optimization', 'demand_forecast', 'cost_analysis', 'supplier_performance')),
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    recommendations JSONB,
    confidence_score DECIMAL(3,2) CHECK (confidence_score BETWEEN 0 AND 1),
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_acknowledged BOOLEAN DEFAULT false,
    acknowledged_by INTEGER REFERENCES users(id),
    acknowledged_at TIMESTAMP
);

-- Patient Portal tables
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

CREATE TABLE patient_health_records (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER NOT NULL REFERENCES patients(id),
    record_type VARCHAR(50) NOT NULL CHECK (record_type IN ('vaccination', 'surgery', 'allergy', 'medication', 'condition')),
    title VARCHAR(200) NOT NULL,
    description TEXT,
    date_recorded DATE NOT NULL,
    doctor_id INTEGER REFERENCES users(id),
    is_visible_to_patient BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE patient_support_tickets (
    id SERIAL PRIMARY KEY,
    ticket_number VARCHAR(20) NOT NULL,
    patient_id INTEGER NOT NULL REFERENCES patients(id),
    location_id INTEGER NOT NULL REFERENCES locations(id),
    subject VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    priority VARCHAR(20) DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high', 'urgent')),
    status VARCHAR(20) DEFAULT 'open' CHECK (status IN ('open', 'in_progress', 'resolved', 'closed')),
    assigned_to INTEGER REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(ticket_number, location_id)
);

-- Front Office tables
CREATE TABLE estimates (
    id SERIAL PRIMARY KEY,
    estimate_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    patient_id INTEGER REFERENCES patients(id),
    patient_name VARCHAR(100),
    patient_phone VARCHAR(15),
    total_amount DECIMAL(10,2) NOT NULL,
    discount_amount DECIMAL(10,2) DEFAULT 0,
    net_amount DECIMAL(10,2) NOT NULL,
    valid_until DATE,
    status VARCHAR(20) DEFAULT 'draft' CHECK (status IN ('draft', 'sent', 'accepted', 'rejected', 'expired')),
    created_by INTEGER NOT NULL REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(estimate_number, location_id)
);

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

-- Investigations table
CREATE TABLE investigations (
    id SERIAL PRIMARY KEY,
    investigation_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    patient_id INTEGER NOT NULL REFERENCES patients(id),
    doctor_id INTEGER NOT NULL REFERENCES users(id),
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

CREATE TABLE user_shifts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id),
    shift_id INTEGER NOT NULL REFERENCES shifts(id),
    shift_date DATE NOT NULL,
    check_in_time TIMESTAMP,
    check_out_time TIMESTAMP,
    status VARCHAR(20) DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'checked_in', 'checked_out', 'absent')),
    notes TEXT
);

-- Inpatient tables
CREATE TABLE advance_collections (
    id SERIAL PRIMARY KEY,
    receipt_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    patient_id INTEGER NOT NULL REFERENCES patients(id),
    admission_id INTEGER REFERENCES admissions(id),
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(20) NOT NULL CHECK (payment_method IN ('cash', 'card', 'upi', 'bank_transfer')),
    collected_by INTEGER NOT NULL REFERENCES users(id),
    purpose TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(receipt_number, location_id)
);

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

CREATE TABLE patient_transfers (
    id SERIAL PRIMARY KEY,
    transfer_number VARCHAR(20) NOT NULL,
    patient_id INTEGER NOT NULL REFERENCES patients(id),
    from_location_id INTEGER NOT NULL REFERENCES locations(id),
    to_location_id INTEGER NOT NULL REFERENCES locations(id),
    from_bed_id INTEGER REFERENCES beds(id),
    to_bed_id INTEGER REFERENCES beds(id),
    transfer_date TIMESTAMP NOT NULL,
    reason TEXT,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'in_transit', 'completed', 'cancelled')),
    transferred_by INTEGER NOT NULL REFERENCES users(id),
    received_by INTEGER REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(transfer_number, from_location_id)
);

-- Billing tables
CREATE TABLE billing_accounts (
    id SERIAL PRIMARY KEY,
    account_code VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    account_name VARCHAR(100) NOT NULL,
    account_type VARCHAR(20) NOT NULL CHECK (account_type IN ('revenue', 'expense', 'asset', 'liability')),
    parent_account_id INTEGER REFERENCES billing_accounts(id),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(account_code, location_id)
);

CREATE TABLE price_lists (
    id SERIAL PRIMARY KEY,
    price_list_code VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    effective_from DATE NOT NULL,
    effective_to DATE,
    is_default BOOLEAN DEFAULT false,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(price_list_code, location_id)
);

CREATE TABLE price_list_items (
    id SERIAL PRIMARY KEY,
    price_list_id INTEGER NOT NULL REFERENCES price_lists(id) ON DELETE CASCADE,
    service_id INTEGER REFERENCES services(id),
    package_id INTEGER REFERENCES packages(id),
    medicine_id INTEGER REFERENCES medicines(id),
    lab_test_id INTEGER REFERENCES lab_tests(id),
    price DECIMAL(10,2) NOT NULL
);

CREATE TABLE cashier_transactions (
    id SERIAL PRIMARY KEY,
    transaction_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    cashier_id INTEGER NOT NULL REFERENCES users(id),
    transaction_type VARCHAR(20) NOT NULL CHECK (transaction_type IN ('payment', 'refund', 'advance')),
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(20) NOT NULL,
    reference_number VARCHAR(50),
    bill_id INTEGER REFERENCES bills(id),
    patient_id INTEGER REFERENCES patients(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE quick_bills (
    id SERIAL PRIMARY KEY,
    quick_bill_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    patient_name VARCHAR(100) NOT NULL,
    patient_phone VARCHAR(15),
    total_amount DECIMAL(10,2) NOT NULL,
    paid_amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(20) NOT NULL,
    created_by INTEGER NOT NULL REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(quick_bill_number, location_id)
);

CREATE TABLE quick_bill_items (
    id SERIAL PRIMARY KEY,
    quick_bill_id INTEGER NOT NULL REFERENCES quick_bills(id) ON DELETE CASCADE,
    item_name VARCHAR(100) NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL
);

-- Create all indexes
CREATE INDEX idx_locations_code ON locations(location_code);
CREATE INDEX idx_users_location ON users(location_id);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_patients_location ON patients(location_id);
CREATE INDEX idx_patients_patient_id ON patients(patient_id);
CREATE INDEX idx_appointments_location ON appointments(location_id);
CREATE INDEX idx_appointments_patient_id ON appointments(patient_id);
CREATE INDEX idx_appointments_doctor_id ON appointments(doctor_id);
CREATE INDEX idx_appointments_date ON appointments(appointment_date);
CREATE INDEX idx_vitals_patient_id ON vitals(patient_id);
CREATE INDEX idx_bills_location ON bills(location_id);
CREATE INDEX idx_bills_patient_id ON bills(patient_id);
CREATE INDEX idx_medicines_location ON medicines(location_id);
CREATE INDEX idx_prescriptions_location ON prescriptions(location_id);
CREATE INDEX idx_prescriptions_patient_id ON prescriptions(patient_id);
CREATE INDEX idx_prescriptions_doctor_id ON prescriptions(doctor_id);
CREATE INDEX idx_lab_orders_location ON lab_orders(location_id);
CREATE INDEX idx_lab_orders_patient_id ON lab_orders(patient_id);
CREATE INDEX idx_beds_location ON beds(location_id);
CREATE INDEX idx_admissions_location ON admissions(location_id);
CREATE INDEX idx_admissions_patient_id ON admissions(patient_id);
CREATE INDEX idx_admissions_bed_id ON admissions(bed_id);
CREATE INDEX idx_vendors_location ON vendors(location_id);
CREATE INDEX idx_items_location ON items(location_id);
CREATE INDEX idx_purchase_orders_location ON purchase_orders(location_id);
CREATE INDEX idx_grn_location ON grn(location_id);
CREATE INDEX idx_central_pharmacy_items_location ON central_pharmacy_items(location_id);
CREATE INDEX idx_pharmacy_indents_location ON pharmacy_indents(location_id);
CREATE INDEX idx_rfq_location ON rfq(location_id);
CREATE INDEX idx_contracts_location ON contracts(location_id);
CREATE INDEX idx_material_schemes_location ON material_schemes(location_id);
CREATE INDEX idx_ai_insights_location ON ai_insights(location_id);
CREATE INDEX idx_patient_portal_access_patient ON patient_portal_access(patient_id);
CREATE INDEX idx_patient_health_records_patient ON patient_health_records(patient_id);
CREATE INDEX idx_patient_support_tickets_location ON patient_support_tickets(location_id);
CREATE INDEX idx_estimates_location ON estimates(location_id);
CREATE INDEX idx_investigations_location ON investigations(location_id);
CREATE INDEX idx_shifts_location ON shifts(location_id);
CREATE INDEX idx_advance_collections_location ON advance_collections(location_id);
CREATE INDEX idx_inpatient_census_location ON inpatient_census(location_id);
CREATE INDEX idx_patient_transfers_from_location ON patient_transfers(from_location_id);
CREATE INDEX idx_billing_accounts_location ON billing_accounts(location_id);
CREATE INDEX idx_price_lists_location ON price_lists(location_id);
CREATE INDEX idx_cashier_transactions_location ON cashier_transactions(location_id);
CREATE INDEX idx_quick_bills_location ON quick_bills(location_id);
CREATE INDEX idx_telecaller_followups_location ON telecaller_followups(location_id);
CREATE INDEX idx_telecaller_followups_patient ON telecaller_followups(patient_id);
CREATE INDEX idx_patient_queue_location ON patient_queue(location_id);
CREATE INDEX idx_communications_location ON communications(location_id);-- COMPLETE SAMPLE DATA FOR ALL TABLES

-- Insert sample locations
INSERT INTO locations (location_code, name, address, phone, email) VALUES
('LOC001', 'Main Hospital', '123 Hospital Street, City Center, State 12345', '9876543200', 'main@hospital.com'),
('LOC002', 'Branch Clinic North', '456 North Avenue, North District, State 12346', '9876543201', 'north@hospital.com'),
('LOC003', 'Branch Clinic South', '789 South Road, South District, State 12347', '9876543202', 'south@hospital.com');

-- Insert sample users
INSERT INTO users (username, email, password, first_name, last_name, role, location_id, phone, department, specialization, license_number) VALUES
('admin', 'admin@hospital.com', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', 'Admin', 'User', 'admin', 1, '9876543210', 'Administration', NULL, NULL),
('dr.smith', 'dr.smith@hospital.com', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', 'John', 'Smith', 'doctor', 1, '9876543211', 'Cardiology', 'Interventional Cardiology', 'DOC001'),
('dr.johnson', 'dr.johnson@hospital.com', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', 'Sarah', 'Johnson', 'doctor', 2, '9876543212', 'Pediatrics', 'Child Development', 'DOC002'),
('dr.williams', 'dr.williams@hospital.com', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', 'Michael', 'Williams', 'doctor', 1, '9876543213', 'Orthopedics', 'Joint Replacement', 'DOC003'),
('nurse.mary', 'nurse.mary@hospital.com', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', 'Mary', 'Wilson', 'nurse', 1, '9876543214', 'General Ward', NULL, 'NUR001'),
('pharmacist.bob', 'pharmacist.bob@hospital.com', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', 'Bob', 'Anderson', 'pharmacist', 1, '9876543215', 'Pharmacy', NULL, 'PHA001'),
('lab.tech', 'lab.tech@hospital.com', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', 'Lisa', 'Brown', 'lab_technician', 1, '9876543216', 'Laboratory', NULL, 'LAB001'),
('front.desk', 'front.desk@hospital.com', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', 'Emma', 'Davis', 'front_office', 1, '9876543217', 'Front Office', NULL, NULL),
('telecaller1', 'telecaller1@hospital.com', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', 'Mike', 'Taylor', 'telecaller', 1, '9876543218', 'Customer Service', NULL, NULL),
('billing.clerk', 'billing.clerk@hospital.com', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', 'Anna', 'Miller', 'billing', 1, '9876543219', 'Billing', NULL, NULL),
('material.mgr', 'material.mgr@hospital.com', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', 'David', 'Garcia', 'material_manager', 1, '9876543220', 'Material Management', NULL, NULL);

-- Insert sample patients
INSERT INTO patients (patient_id, location_id, first_name, last_name, date_of_birth, gender, phone, email, address, emergency_contact, blood_group, allergies, medical_history, insurance_number) VALUES
('PAT000001', 1, 'James', 'Wilson', '1985-03-15', 'male', '9123456789', 'james.wilson@email.com', '123 Main St, City, State 12345', '9123456790', 'O+', 'Penicillin allergy', 'Hypertension, Diabetes Type 2', 'INS001234567'),
('PAT000002', 1, 'Maria', 'Garcia', '1990-07-22', 'female', '9123456788', 'maria.garcia@email.com', '456 Oak Ave, City, State 12345', '9123456791', 'A+', 'None known', 'Asthma', 'INS001234568'),
('PAT000001', 2, 'Robert', 'Johnson', '1978-11-08', 'male', '9123456787', 'robert.johnson@email.com', '789 Pine St, North District, State 12346', '9123456792', 'B+', 'Shellfish allergy', 'Heart disease family history', NULL),
('PAT000003', 1, 'Jennifer', 'Brown', '1995-05-12', 'female', '9123456786', 'jennifer.brown@email.com', '321 Elm St, City, State 12345', '9123456793', 'AB+', 'Latex allergy', 'None significant', NULL),
('PAT000004', 1, 'Michael', 'Davis', '1982-09-30', 'male', '9123456785', 'michael.davis@email.com', '654 Maple Ave, City, State 12345', '9123456794', 'O-', 'None known', 'Migraine history', 'INS001234570'),
('PAT000005', 1, 'Sarah', 'Thompson', '1988-12-08', 'female', '9123456784', 'sarah.thompson@email.com', '789 Elm Street, City, State 12345', '9123456795', 'A-', 'Dust allergy', 'Thyroid disorder', 'INS001234571'),
('PAT000006', 1, 'David', 'Miller', '1975-06-20', 'male', '9123456783', 'david.miller@email.com', '456 Pine Avenue, City, State 12345', '9123456796', 'B-', 'None known', 'Hypertension', 'INS001234572'),
('PAT000002', 2, 'Lisa', 'Anderson', '1992-09-14', 'female', '9123456782', 'lisa.anderson@email.com', '123 Oak Road, North District, State 12346', '9123456797', 'O+', 'Peanut allergy', 'None significant', NULL),
('PAT000007', 1, 'Mark', 'Taylor', '1980-04-25', 'male', '9123456781', 'mark.taylor@email.com', '321 Maple Street, City, State 12345', '9123456798', 'AB-', 'None known', 'Diabetes Type 1', 'INS001234573'),
('PAT000008', 1, 'Emily', 'White', '1995-11-30', 'female', '9123456780', 'emily.white@email.com', '654 Cedar Avenue, City, State 12345', '9123456799', 'A+', 'Latex allergy', 'Asthma', NULL);

-- Insert sample services
INSERT INTO services (service_code, location_id, name, category, price, description) VALUES
('SRV001', 1, 'General Consultation', 'Consultation', 500.00, 'General physician consultation'),
('SRV002', 1, 'Cardiology Consultation', 'Consultation', 800.00, 'Specialist cardiology consultation'),
('SRV003', 1, 'ECG', 'Diagnostic', 300.00, 'Electrocardiogram test'),
('SRV004', 1, 'X-Ray Chest', 'Radiology', 400.00, 'Chest X-ray examination'),
('SRV005', 1, 'Blood Test', 'Laboratory', 250.00, 'Complete blood count test'),
('SRV006', 1, 'Physiotherapy Session', 'Therapy', 350.00, 'Physical therapy session'),
('SRV007', 1, 'Dietician Consultation', 'Consultation', 400.00, 'Nutritional counseling'),
('SRV008', 1, 'Ultrasound Scan', 'Radiology', 800.00, 'Ultrasound examination'),
('SRV009', 1, 'CT Scan', 'Radiology', 2500.00, 'Computed tomography scan'),
('SRV010', 1, 'MRI Scan', 'Radiology', 5000.00, 'Magnetic resonance imaging'),
('SRV011', 1, 'Endoscopy', 'Procedure', 3000.00, 'Endoscopic examination'),
('SRV012', 1, 'Minor Surgery', 'Surgery', 8000.00, 'Minor surgical procedure'),
('SRV013', 1, 'Dressing', 'Nursing', 150.00, 'Wound dressing service'),
('SRV014', 1, 'Injection', 'Nursing', 50.00, 'Injection administration'),
('SRV015', 1, 'IV Cannulation', 'Nursing', 200.00, 'Intravenous cannula insertion'),
('SRV001', 2, 'General Consultation', 'Consultation', 450.00, 'General physician consultation'),
('SRV002', 2, 'Pediatric Consultation', 'Consultation', 600.00, 'Pediatric specialist consultation'),
('SRV003', 2, 'ECG', 'Diagnostic', 280.00, 'Electrocardiogram test'),
('SRV004', 2, 'X-Ray', 'Radiology', 350.00, 'X-ray examination'),
('SRV005', 2, 'Blood Test', 'Laboratory', 230.00, 'Complete blood count test');

-- Insert sample packages
INSERT INTO packages (package_code, location_id, name, description, total_price, discounted_price) VALUES
('PKG001', 1, 'Basic Health Checkup', 'Complete basic health screening package', 2500.00, 2000.00),
('PKG002', 1, 'Cardiac Screening', 'Comprehensive cardiac health package', 5000.00, 4200.00),
('PKG003', 1, 'Diabetes Management Package', 'Comprehensive diabetes care package', 3500.00, 2800.00),
('PKG004', 1, 'Women Health Checkup', 'Complete health screening for women', 4000.00, 3200.00),
('PKG005', 1, 'Senior Citizen Package', 'Health checkup package for elderly', 3000.00, 2400.00),
('PKG006', 1, 'Pre-Employment Checkup', 'Medical fitness certificate package', 1500.00, 1200.00),
('PKG001', 2, 'Basic Health Checkup', 'Complete basic health screening package', 2200.00, 1800.00),
('PKG002', 2, 'Child Health Package', 'Comprehensive child health package', 2800.00, 2300.00);

-- Insert sample package services
INSERT INTO package_services (package_id, service_id, quantity) VALUES
(1, 1, 1), (1, 3, 1), (1, 5, 1),
(2, 2, 1), (2, 3, 1), (2, 4, 1),
(3, 1, 1), (3, 2, 1), (3, 5, 1),
(4, 1, 1), (4, 8, 1), (4, 5, 1),
(5, 1, 1), (5, 3, 1), (5, 4, 1),
(6, 1, 1), (6, 4, 1), (6, 5, 1),
(7, 16, 1), (7, 18, 1), (7, 20, 1),
(8, 17, 1), (8, 18, 1), (8, 20, 1);

-- Insert sample discounts
INSERT INTO discounts (discount_code, location_id, name, type, value, min_amount, max_discount, valid_from, valid_to) VALUES
('SENIOR10', 1, 'Senior Citizen Discount', 'percentage', 10.00, 500.00, 1000.00, '2024-01-01', '2024-12-31'),
('STAFF20', 1, 'Staff Discount', 'percentage', 20.00, 100.00, 2000.00, '2024-01-01', '2024-12-31'),
('NEWPATIENT', 1, 'New Patient Discount', 'fixed', 100.00, 1000.00, 100.00, '2024-01-01', '2024-12-31'),
('EMERGENCY', 1, 'Emergency Discount', 'percentage', 15.00, 1000.00, 500.00, '2024-01-01', '2024-12-31'),
('FAMILY', 1, 'Family Package Discount', 'fixed', 200.00, 2000.00, 200.00, '2024-01-01', '2024-12-31'),
('STUDENT', 1, 'Student Discount', 'percentage', 25.00, 500.00, 300.00, '2024-01-01', '2024-12-31'),
('CORPORATE', 1, 'Corporate Discount', 'percentage', 12.00, 2000.00, 1500.00, '2024-01-01', '2024-12-31'),
('SENIOR10', 2, 'Senior Citizen Discount', 'percentage', 10.00, 400.00, 800.00, '2024-01-01', '2024-12-31'),
('STAFF15', 2, 'Staff Discount', 'percentage', 15.00, 100.00, 1500.00, '2024-01-01', '2024-12-31');

-- Insert sample medicines
INSERT INTO medicines (medicine_code, location_id, name, generic_name, manufacturer, category, unit_price, stock_quantity, min_stock_level, expiry_date, batch_number) VALUES
('MED001', 1, 'Paracetamol 500mg', 'Paracetamol', 'PharmaCorp', 'Analgesic', 2.50, 1000, 100, '2025-12-31', 'BATCH001'),
('MED002', 1, 'Amoxicillin 250mg', 'Amoxicillin', 'MediLab', 'Antibiotic', 15.75, 500, 50, '2025-06-30', 'BATCH002'),
('MED003', 1, 'Metformin 500mg', 'Metformin HCl', 'DiabetCare', 'Antidiabetic', 8.25, 800, 80, '2025-09-15', 'BATCH003'),
('MED004', 1, 'Lisinopril 10mg', 'Lisinopril', 'CardioMed', 'ACE Inhibitor', 12.50, 300, 30, '2025-11-20', 'BATCH004'),
('MED005', 1, 'Omeprazole 20mg', 'Omeprazole', 'GastroPharm', 'PPI', 18.90, 400, 40, '2025-08-10', 'BATCH005'),
('MED006', 1, 'Aspirin 75mg', 'Aspirin', 'CardioMed', 'Antiplatelet', 3.50, 600, 60, '2025-10-15', 'BATCH006'),
('MED007', 1, 'Azithromycin 500mg', 'Azithromycin', 'Cipla', 'Antibiotic', 45.00, 300, 30, '2025-07-15', 'BATCH007'),
('MED008', 1, 'Cetirizine 10mg', 'Cetirizine', 'Dr Reddys', 'Antihistamine', 3.25, 500, 50, '2025-11-30', 'BATCH008'),
('MED009', 1, 'Diclofenac 50mg', 'Diclofenac', 'Novartis', 'NSAID', 6.75, 400, 40, '2025-09-10', 'BATCH009'),
('MED010', 1, 'Ranitidine 150mg', 'Ranitidine', 'GSK', 'H2 Blocker', 4.50, 600, 60, '2025-08-20', 'BATCH010'),
('MED011', 1, 'Salbutamol Inhaler', 'Salbutamol', 'Cipla', 'Bronchodilator', 125.00, 150, 15, '2025-12-05', 'BATCH011'),
('MED012', 1, 'Insulin Regular', 'Human Insulin', 'Novo Nordisk', 'Antidiabetic', 380.00, 80, 8, '2025-06-25', 'BATCH012'),
('MED001', 2, 'Paracetamol 500mg', 'Paracetamol', 'PharmaCorp', 'Analgesic', 2.50, 800, 80, '2025-12-31', 'BATCH013'),
('MED002', 2, 'Amoxicillin 250mg', 'Amoxicillin', 'MediLab', 'Antibiotic', 15.75, 400, 40, '2025-06-30', 'BATCH014'),
('MED008', 2, 'Cetirizine 10mg', 'Cetirizine', 'Dr Reddys', 'Antihistamine', 3.25, 300, 30, '2025-11-30', 'BATCH015');

-- Insert sample lab tests
INSERT INTO lab_tests (test_code, location_id, test_name, category, price, normal_range, unit, sample_type) VALUES
('LAB001', 1, 'Complete Blood Count', 'Hematology', 250.00, 'Various parameters', 'Multiple', 'Blood'),
('LAB002', 1, 'Blood Glucose Fasting', 'Biochemistry', 150.00, '70-100', 'mg/dL', 'Blood'),
('LAB003', 1, 'Lipid Profile', 'Biochemistry', 400.00, 'Various parameters', 'mg/dL', 'Blood'),
('LAB004', 1, 'Thyroid Function Test', 'Endocrinology', 500.00, 'TSH: 0.4-4.0', 'mIU/L', 'Blood'),
('LAB005', 1, 'Liver Function Test', 'Biochemistry', 350.00, 'Various parameters', 'U/L', 'Blood'),
('LAB006', 1, 'Urine Routine', 'Pathology', 200.00, 'Normal', 'Various', 'Urine'),
('LAB007', 1, 'HbA1c', 'Biochemistry', 300.00, '4.0-5.6%', '%', 'Blood'),
('LAB008', 1, 'Creatinine', 'Biochemistry', 120.00, '0.6-1.2', 'mg/dL', 'Blood'),
('LAB009', 1, 'ESR', 'Hematology', 80.00, '0-20', 'mm/hr', 'Blood'),
('LAB010', 1, 'CRP', 'Immunology', 200.00, '<3.0', 'mg/L', 'Blood'),
('LAB011', 1, 'Vitamin D', 'Biochemistry', 800.00, '30-100', 'ng/mL', 'Blood'),
('LAB012', 1, 'Vitamin B12', 'Biochemistry', 600.00, '200-900', 'pg/mL', 'Blood'),
('LAB013', 1, 'Stool Routine', 'Pathology', 150.00, 'Normal', 'Various', 'Stool'),
('LAB014', 1, 'Pregnancy Test', 'Immunology', 100.00, 'Negative/Positive', 'Qualitative', 'Urine'),
('LAB001', 2, 'Complete Blood Count', 'Hematology', 230.00, 'Various parameters', 'Multiple', 'Blood'),
('LAB002', 2, 'Blood Glucose Fasting', 'Biochemistry', 140.00, '70-100', 'mg/dL', 'Blood'),
('LAB006', 2, 'Urine Routine', 'Pathology', 180.00, 'Normal', 'Various', 'Urine');

-- Insert sample beds
INSERT INTO beds (bed_number, location_id, ward, bed_type, price_per_day) VALUES
('ICU-001', 1, 'ICU', 'icu', 5000.00),
('ICU-002', 1, 'ICU', 'icu', 5000.00),
('ICU-003', 1, 'ICU', 'icu', 5000.00),
('GEN-001', 1, 'General Ward A', 'general', 1500.00),
('GEN-002', 1, 'General Ward A', 'general', 1500.00),
('GEN-003', 1, 'General Ward B', 'general', 1500.00),
('GEN-004', 1, 'General Ward B', 'general', 1500.00),
('GEN-005', 1, 'General Ward C', 'general', 1500.00),
('PVT-001', 1, 'Private Ward', 'private', 3000.00),
('PVT-002', 1, 'Private Ward', 'private', 3000.00),
('PVT-003', 1, 'Private Ward', 'private', 3000.00),
('EMR-001', 1, 'Emergency', 'emergency', 2000.00),
('EMR-002', 1, 'Emergency', 'emergency', 2000.00),
('EMR-003', 1, 'Emergency', 'emergency', 2000.00),
('ICU-001', 2, 'ICU North', 'icu', 4500.00),
('ICU-002', 2, 'ICU North', 'icu', 4500.00),
('GEN-001', 2, 'General Ward North', 'general', 1300.00),
('GEN-002', 2, 'General Ward North', 'general', 1300.00),
('PVT-001', 2, 'Private Ward North', 'private', 2800.00),
('EMR-001', 2, 'Emergency North', 'emergency', 1800.00);

-- Insert sample insurance companies
INSERT INTO insurance_companies (name, code, contact_person, phone, email, address) VALUES
('National Health Insurance', 'NHI', 'John Manager', '9876543220', 'contact@nhi.com', '100 Insurance Plaza, City'),
('Star Health Insurance', 'STAR', 'Sarah Director', '9876543221', 'info@starhealth.com', '200 Health Tower, City'),
('HDFC ERGO Health', 'HDFC', 'Mike Executive', '9876543222', 'support@hdfcergo.com', '300 HDFC Building, City'),
('ICICI Lombard Health', 'ICICI', 'Lisa Coordinator', '9876543223', 'help@icicilombard.com', '400 ICICI Center, City'),
('Max Bupa Health', 'MAXBUPA', 'Robert Manager', '9876543224', 'care@maxbupa.com', '500 Max Tower, City'),
('Care Health Insurance', 'CARE', 'Jennifer Head', '9876543225', 'support@careinsurance.com', '600 Care Plaza, City');

-- Insert sample TPA companies
INSERT INTO tpa_companies (name, code, contact_person, phone, email, address) VALUES
('MediAssist TPA', 'MEDI', 'Robert TPA Manager', '9876543226', 'contact@mediassist.com', '700 TPA Plaza, City'),
('Vidal Health TPA', 'VIDAL', 'Jennifer TPA Head', '9876543227', 'info@vidalhealth.com', '800 Vidal Tower, City'),
('Paramount TPA', 'PARAM', 'David TPA Director', '9876543228', 'support@paramounttpa.com', '900 Paramount Building, City'),
('Good Health TPA', 'GOODH', 'Maria TPA Manager', '9876543229', 'help@goodhealthtpa.com', '1000 Good Health Center, City');

-- Insert sample insurance rates
INSERT INTO insurance_rates (location_id, insurance_company_id, service_id, coverage_percentage, max_coverage_amount) VALUES
(1, 1, 1, 80.00, 400.00), (1, 1, 2, 70.00, 560.00), (1, 1, 3, 100.00, 300.00),
(1, 2, 1, 90.00, 450.00), (1, 2, 2, 75.00, 600.00), (1, 2, 3, 100.00, 300.00),
(1, 3, 1, 85.00, 425.00), (1, 3, 2, 80.00, 640.00), (1, 3, 4, 90.00, 360.00),
(1, 4, 1, 75.00, 375.00), (1, 4, 2, 70.00, 560.00), (1, 4, 5, 100.00, 250.00),
(2, 1, 16, 80.00, 360.00), (2, 1, 17, 75.00, 450.00), (2, 2, 16, 90.00, 405.00);

-- Insert sample vendors
INSERT INTO vendors (vendor_code, location_id, name, contact_person, phone, email, address, gst_number, pan_number) VALUES
('VEN001', 1, 'MedSupply Corp', 'Alex Johnson', '9876543230', 'alex@medsupply.com', '1100 Supply Street, City', 'GST123456789', 'PAN123456'),
('VEN002', 1, 'HealthEquip Ltd', 'Maria Rodriguez', '9876543231', 'maria@healthequip.com', '1200 Equipment Ave, City', 'GST987654321', 'PAN987654'),
('VEN003', 1, 'PharmaDist Inc', 'Carlos Martinez', '9876543232', 'carlos@pharmadist.com', '1300 Pharma Road, City', 'GST456789123', 'PAN456789'),
('VEN004', 1, 'BioMed Solutions', 'Dr. Rajesh Kumar', '9876543233', 'rajesh@biomed.com', '1400 Medical Plaza, City', 'GST789123456', 'PAN789123'),
('VEN005', 1, 'TechCare Equipment', 'Ms. Priya Sharma', '9876543234', 'priya@techcare.com', '1500 Tech Street, City', 'GST321654987', 'PAN321654'),
('VEN006', 2, 'North Medical Supply', 'Mr. Amit Patel', '9876543235', 'amit@northmed.com', '1600 North Avenue, North City', 'GST654321789', 'PAN654321'),
('VEN007', 1, 'Surgical Instruments Co', 'Dr. Neha Singh', '9876543236', 'neha@surgicalinst.com', '1700 Surgical Street, City', 'GST147258369', 'PAN147258'),
('VEN008', 1, 'Laboratory Solutions', 'Mr. Vikram Gupta', '9876543237', 'vikram@labsolutions.com', '1800 Lab Avenue, City', 'GST963852741', 'PAN963852');

-- Insert sample items
INSERT INTO items (item_code, location_id, name, category, unit, unit_price, stock_quantity, min_stock_level) VALUES
('ITM001', 1, 'Surgical Gloves', 'Medical Supplies', 'Box', 150.00, 500, 50),
('ITM002', 1, 'Syringes 5ml', 'Medical Supplies', 'Pack', 75.00, 1000, 100),
('ITM003', 1, 'Bandages', 'Medical Supplies', 'Roll', 25.00, 200, 20),
('ITM004', 1, 'Cotton Swabs', 'Medical Supplies', 'Pack', 30.00, 300, 30),
('ITM005', 1, 'Surgical Masks', 'Medical Supplies', 'Box', 120.00, 400, 40),
('ITM006', 1, 'Thermometer Digital', 'Medical Equipment', 'Piece', 250.00, 50, 5),
('ITM007', 1, 'Blood Pressure Monitor', 'Medical Equipment', 'Piece', 1500.00, 20, 2),
('ITM008', 1, 'Stethoscope', 'Medical Equipment', 'Piece', 800.00, 30, 3),
('ITM009', 1, 'Pulse Oximeter', 'Medical Equipment', 'Piece', 1200.00, 25, 3),
('ITM010', 1, 'Wheelchair', 'Medical Equipment', 'Piece', 5000.00, 10, 1),
('ITM011', 1, 'Hospital Bed', 'Furniture', 'Piece', 25000.00, 5, 1),
('ITM012', 1, 'IV Stand', 'Medical Equipment', 'Piece', 800.00, 15, 2),
('ITM013', 1, 'Oxygen Cylinder', 'Medical Equipment', 'Piece', 3500.00, 8, 2),
('ITM014', 1, 'Nebulizer', 'Medical Equipment', 'Piece', 2200.00, 12, 2),
('ITM015', 1, 'ECG Machine', 'Medical Equipment', 'Piece', 45000.00, 3, 1),
('ITM001', 2, 'Surgical Gloves', 'Medical Supplies', 'Box', 140.00, 300, 30),
('ITM002', 2, 'Syringes 5ml', 'Medical Supplies', 'Pack', 70.00, 600, 60),
('ITM003', 2, 'Bandages', 'Medical Supplies', 'Roll', 23.00, 150, 15);

-- Continue with more sample data in next part...

-- COMPREHENSIVE SAMPLE DATA FOR ALL HIMS TABLES
-- This section contains sample data for every table in the HIMS database

-- Sample appointments
INSERT INTO appointments (appointment_number, location_id, patient_id, doctor_id, appointment_date, type, status, reason, consultation_fee) VALUES
('APT000001', 1, 1, 2, '2024-01-15 09:00:00', 'consultation', 'completed', 'Chest pain', 800.00),
('APT000002', 1, 2, 4, '2024-01-15 10:30:00', 'follow_up', 'completed', 'Diabetes follow-up', 500.00),
('APT000003', 1, 3, 2, '2024-01-16 14:00:00', 'consultation', 'scheduled', 'Hypertension check', 800.00),
('APT000004', 2, 4, 3, '2024-01-16 11:00:00', 'routine_checkup', 'confirmed', 'Annual checkup', 600.00),
('APT000005', 1, 5, 4, '2024-01-17 15:30:00', 'emergency', 'in_progress', 'Severe headache', 500.00);

-- Sample vitals
INSERT INTO vitals (location_id, patient_id, appointment_id, recorded_by, height, weight, bmi, temperature, blood_pressure_systolic, blood_pressure_diastolic, pulse_rate, respiratory_rate, oxygen_saturation, blood_sugar) VALUES
(1, 1, 1, 5, 175.0, 75.5, 24.7, 98.6, 140, 90, 78, 18, 98.5, 110.0),
(1, 2, 2, 5, 162.0, 58.2, 22.2, 98.4, 120, 80, 72, 16, 99.0, 95.0),
(1, 3, NULL, 5, 180.0, 82.0, 25.3, 99.1, 150, 95, 85, 20, 97.8, 180.0),
(2, 4, 4, 5, 168.0, 65.0, 23.0, 98.2, 110, 70, 68, 15, 99.2, 88.0),
(1, 5, 5, 5, 170.0, 70.0, 24.2, 100.2, 160, 100, 90, 22, 96.5, 200.0);

-- Sample bills
INSERT INTO bills (bill_number, location_id, patient_id, appointment_id, total_amount, discount_amount, tax_amount, net_amount, paid_amount, status, payment_method, created_by) VALUES
('BILL000001', 1, 1, 1, 1100.00, 100.00, 150.00, 1150.00, 1150.00, 'paid', 'card', 10),
('BILL000002', 1, 2, 2, 750.00, 0.00, 112.50, 862.50, 862.50, 'paid', 'cash', 10),
('BILL000003', 1, 3, NULL, 2500.00, 200.00, 345.00, 2645.00, 1000.00, 'partially_paid', 'upi', 10),
('BILL000004', 2, 4, 4, 830.00, 83.00, 112.05, 859.05, 859.05, 'paid', 'insurance', 10),
('BILL000005', 1, 5, 5, 1200.00, 0.00, 180.00, 1380.00, 0.00, 'pending', NULL, 10);

-- Sample bill items
INSERT INTO bill_items (bill_id, item_name, item_code, quantity, unit_price, total_price, category) VALUES
(1, 'Cardiology Consultation', 'SRV002', 1, 800.00, 800.00, 'Consultation'),
(1, 'ECG', 'SRV003', 1, 300.00, 300.00, 'Diagnostic'),
(2, 'General Consultation', 'SRV001', 1, 500.00, 500.00, 'Consultation'),
(2, 'Blood Test', 'SRV005', 1, 250.00, 250.00, 'Laboratory'),
(3, 'Basic Health Checkup', 'PKG001', 1, 2500.00, 2500.00, 'Package'),
(4, 'Pediatric Consultation', 'SRV002', 1, 600.00, 600.00, 'Consultation'),
(4, 'Blood Test', 'SRV005', 1, 230.00, 230.00, 'Laboratory'),
(5, 'General Consultation', 'SRV001', 1, 500.00, 500.00, 'Consultation'),
(5, 'CT Scan', 'SRV009', 1, 2500.00, 2500.00, 'Radiology');

-- Sample prescriptions
INSERT INTO prescriptions (prescription_number, location_id, patient_id, doctor_id, appointment_id, status, notes) VALUES
('PRE000001', 1, 1, 2, 1, 'dispensed', 'Take medications as prescribed'),
('PRE000002', 1, 2, 4, 2, 'dispensed', 'Continue diabetes medication'),
('PRE000003', 1, 3, 2, NULL, 'pending', 'New prescription for hypertension'),
('PRE000004', 2, 4, 3, 4, 'dispensed', 'Routine medication'),
('PRE000005', 1, 5, 4, 5, 'pending', 'Pain management medication');

-- Sample prescription items
INSERT INTO prescription_items (prescription_id, medicine_id, quantity, dosage, frequency, duration, instructions) VALUES
(1, 1, 30, '500mg', 'Twice daily', 15, 'Take after meals'),
(1, 6, 30, '75mg', 'Once daily', 30, 'Take in morning'),
(2, 3, 60, '500mg', 'Twice daily', 30, 'Take before meals'),
(2, 1, 20, '500mg', 'As needed', 10, 'For fever or pain'),
(3, 4, 30, '10mg', 'Once daily', 30, 'Take in morning'),
(4, 8, 10, '10mg', 'Once daily', 10, 'For allergy'),
(5, 9, 20, '50mg', 'Twice daily', 10, 'Take with food');

-- Sample prescription templates
INSERT INTO prescription_templates (template_name, location_id, doctor_id, diagnosis, template_data) VALUES
('Hypertension Standard', 1, 2, 'Essential Hypertension', '{"medicines": [{"id": 4, "dosage": "10mg", "frequency": "Once daily", "duration": 30}]}'),
('Diabetes Type 2', 1, 4, 'Type 2 Diabetes Mellitus', '{"medicines": [{"id": 3, "dosage": "500mg", "frequency": "Twice daily", "duration": 30}]}'),
('Common Cold', 1, 2, 'Upper Respiratory Tract Infection', '{"medicines": [{"id": 1, "dosage": "500mg", "frequency": "Twice daily", "duration": 5}, {"id": 8, "dosage": "10mg", "frequency": "Once daily", "duration": 5}]}');

-- Sample pharmacy sales
INSERT INTO pharmacy_sales (sale_number, location_id, patient_id, prescription_id, total_amount, discount_amount, net_amount, payment_method, sold_by) VALUES
('SALE000001', 1, 1, 1, 180.00, 18.00, 162.00, 'cash', 6),
('SALE000002', 1, 2, 2, 525.00, 0.00, 525.00, 'card', 6),
('SALE000003', 2, 4, 4, 32.50, 3.25, 29.25, 'upi', 6),
('SALE000004', 1, NULL, NULL, 75.00, 0.00, 75.00, 'cash', 6),
('SALE000005', 1, 5, 5, 135.00, 13.50, 121.50, 'card', 6);

-- Sample pharmacy sale items
INSERT INTO pharmacy_sale_items (sale_id, medicine_id, quantity, unit_price, total_price) VALUES
(1, 1, 30, 2.50, 75.00), (1, 6, 30, 3.50, 105.00),
(2, 3, 60, 8.25, 495.00), (2, 1, 12, 2.50, 30.00),
(3, 8, 10, 3.25, 32.50),
(4, 1, 30, 2.50, 75.00),
(5, 9, 20, 6.75, 135.00);

-- Sample lab orders
INSERT INTO lab_orders (order_number, location_id, patient_id, doctor_id, appointment_id, status, collection_date, report_date, notes) VALUES
('LAB000001', 1, 1, 2, 1, 'completed', '2024-01-15 10:00:00', '2024-01-15 16:00:00', 'Cardiac workup'),
('LAB000002', 1, 2, 4, 2, 'completed', '2024-01-15 11:00:00', '2024-01-15 17:00:00', 'Diabetes monitoring'),
('LAB000003', 1, 3, 2, NULL, 'processing', '2024-01-16 09:00:00', NULL, 'Routine checkup'),
('LAB000004', 2, 4, 3, 4, 'completed', '2024-01-16 10:00:00', '2024-01-16 15:00:00', 'Annual screening'),
('LAB000005', 1, 5, 4, 5, 'ordered', NULL, NULL, 'Emergency workup');

-- Sample lab order items
INSERT INTO lab_order_items (order_id, test_id, result, status, remarks) VALUES
(1, 1, 'WBC: 7500, RBC: 4.5M, Hgb: 14.2', 'completed', 'Normal values'),
(1, 3, 'Total Cholesterol: 220, HDL: 45, LDL: 140', 'completed', 'Borderline high'),
(2, 2, '95 mg/dL', 'completed', 'Normal fasting glucose'),
(2, 7, '6.8%', 'completed', 'Good diabetic control'),
(3, 1, NULL, 'pending', NULL),
(3, 6, NULL, 'pending', NULL),
(4, 15, 'Negative', 'completed', 'Normal'),
(4, 16, '88 mg/dL', 'completed', 'Normal'),
(5, 1, NULL, 'pending', NULL);

-- Sample admissions
INSERT INTO admissions (admission_number, location_id, patient_id, bed_id, doctor_id, admission_date, status, admission_type, diagnosis, notes) VALUES
('ADM000001', 1, 1, 1, 2, '2024-01-15 20:00:00', 'admitted', 'emergency', 'Acute Myocardial Infarction', 'Patient stable, monitoring required'),
('ADM000002', 1, 3, 9, 4, '2024-01-16 08:00:00', 'admitted', 'planned', 'Diabetes management', 'Planned admission for glucose control'),
('ADM000003', 2, 4, 17, 3, '2024-01-16 12:00:00', 'discharged', 'emergency', 'Acute Gastroenteritis', 'Discharged after treatment'),
('ADM000004', 1, 5, 12, 4, '2024-01-17 16:00:00', 'admitted', 'emergency', 'Severe Migraine', 'Under observation');

-- Sample bed transfers
INSERT INTO bed_transfers (admission_id, from_bed_id, to_bed_id, transfer_date, reason, transferred_by) VALUES
(1, 12, 1, '2024-01-15 22:00:00', 'Patient condition deteriorated, moved to ICU', 5),
(2, 4, 9, '2024-01-16 10:00:00', 'Patient requested private room', 5);

-- Sample pre-authorizations
INSERT INTO pre_authorizations (auth_number, location_id, patient_id, insurance_company_id, requested_amount, approved_amount, status, valid_from, valid_to, diagnosis, treatment_plan, created_by) VALUES
('AUTH000001', 1, 1, 1, 50000.00, 40000.00, 'approved', '2024-01-15', '2024-02-15', 'Cardiac Surgery', 'Angioplasty procedure', 8),
('AUTH000002', 1, 2, 2, 25000.00, 25000.00, 'approved', '2024-01-16', '2024-02-16', 'Diabetes Management', 'Inpatient glucose control', 8),
('AUTH000003', 1, 5, 3, 15000.00, NULL, 'pending', '2024-01-17', '2024-02-17', 'Neurological Assessment', 'MRI and specialist consultation', 8);

-- Sample insurance claims
INSERT INTO insurance_claims (claim_number, location_id, patient_id, insurance_company_id, bill_id, pre_auth_id, claim_amount, approved_amount, status, submission_date, approval_date, remarks) VALUES
('CLM000001', 1, 1, 1, 1, 1, 1150.00, 920.00, 'approved', '2024-01-15 18:00:00', '2024-01-16 10:00:00', '80% coverage applied'),
('CLM000002', 2, 4, 2, 4, NULL, 859.05, 773.15, 'paid', '2024-01-16 16:00:00', '2024-01-17 09:00:00', '90% coverage, payment processed'),
('CLM000003', 1, 2, 2, 2, 2, 862.50, NULL, 'under_review', '2024-01-17 12:00:00', NULL, 'Documents under verification');

-- Sample purchase orders
INSERT INTO purchase_orders (po_number, location_id, vendor_id, total_amount, status, order_date, expected_delivery_date, created_by) VALUES
('PO000001', 1, 1, 25000.00, 'received', '2024-01-10', '2024-01-15', 11),
('PO000002', 1, 2, 45000.00, 'approved', '2024-01-12', '2024-01-18', 11),
('PO000003', 1, 3, 15000.00, 'sent', '2024-01-14', '2024-01-20', 11),
('PO000004', 2, 6, 18000.00, 'draft', '2024-01-16', '2024-01-22', 11);

-- Sample purchase order items
INSERT INTO purchase_order_items (po_id, item_id, quantity, unit_price, total_price) VALUES
(1, 1, 100, 150.00, 15000.00), (1, 2, 50, 75.00, 3750.00), (1, 3, 250, 25.00, 6250.00),
(2, 15, 1, 45000.00, 45000.00),
(3, 6, 20, 250.00, 5000.00), (3, 7, 5, 1500.00, 7500.00), (3, 8, 3, 800.00, 2400.00),
(4, 16, 50, 140.00, 7000.00), (4, 17, 100, 70.00, 7000.00), (4, 18, 100, 23.00, 2300.00);

-- Sample GRN
INSERT INTO grn (grn_number, location_id, po_id, vendor_id, invoice_number, invoice_date, total_amount, received_by) VALUES
('GRN000001', 1, 1, 1, 'INV-2024-001', '2024-01-15', 25000.00, 11),
('GRN000002', 1, 2, 2, 'INV-2024-002', '2024-01-18', 45000.00, 11);

-- Sample GRN items
INSERT INTO grn_items (grn_id, item_id, ordered_quantity, received_quantity, unit_price, total_price) VALUES
(1, 1, 100, 100, 150.00, 15000.00), (1, 2, 50, 50, 75.00, 3750.00), (1, 3, 250, 250, 25.00, 6250.00),
(2, 15, 1, 1, 45000.00, 45000.00);

-- Sample stock adjustments
INSERT INTO stock_adjustments (adjustment_number, location_id, item_id, adjustment_type, quantity, reason, adjusted_by) VALUES
('ADJ000001', 1, 1, 'increase', 50, 'Stock received from GRN', 11),
('ADJ000002', 1, 6, 'decrease', 2, 'Damaged items', 11),
('ADJ000003', 1, 10, 'increase', 5, 'Found during stock audit', 11);

-- Sample stock transfers
INSERT INTO stock_transfers (transfer_number, from_location_id, to_location_id, status, transfer_date, transferred_by) VALUES
('TRF000001', 1, 2, 'received', '2024-01-16 10:00:00', 11),
('TRF000002', 1, 3, 'in_transit', '2024-01-17 14:00:00', 11);

-- Sample stock transfer items
INSERT INTO stock_transfer_items (transfer_id, item_id, quantity, received_quantity) VALUES
(1, 1, 50, 50), (1, 2, 30, 30), (1, 3, 100, 100),
(2, 6, 10, 0), (2, 8, 5, 0);

-- Sample doctor schedules
INSERT INTO doctor_schedules (doctor_id, location_id, day_of_week, start_time, end_time) VALUES
(2, 1, 1, '09:00:00', '17:00:00'), (2, 1, 2, '09:00:00', '17:00:00'), (2, 1, 3, '09:00:00', '17:00:00'),
(3, 2, 1, '10:00:00', '18:00:00'), (3, 2, 2, '10:00:00', '18:00:00'), (3, 2, 4, '10:00:00', '18:00:00'),
(4, 1, 1, '08:00:00', '16:00:00'), (4, 1, 3, '08:00:00', '16:00:00'), (4, 1, 5, '08:00:00', '16:00:00');

-- Sample doctor rounds
INSERT INTO doctor_rounds (round_number, location_id, doctor_id, round_date, start_time, end_time, notes) VALUES
('RND000001', 1, 2, '2024-01-15', '2024-01-15 08:00:00', '2024-01-15 10:00:00', 'Morning rounds completed'),
('RND000002', 1, 4, '2024-01-16', '2024-01-16 07:30:00', '2024-01-16 09:30:00', 'All patients stable'),
('RND000003', 2, 3, '2024-01-16', '2024-01-16 08:00:00', '2024-01-16 09:00:00', 'Pediatric ward rounds');

-- Sample doctor round patients
INSERT INTO doctor_round_patients (round_id, patient_id, admission_id, visit_order, notes, visited_at) VALUES
(1, 1, 1, 1, 'Patient responding well to treatment', '2024-01-15 08:15:00'),
(1, 3, 2, 2, 'Glucose levels improving', '2024-01-15 08:45:00'),
(2, 1, 1, 1, 'Continue current medication', '2024-01-16 07:45:00'),
(2, 3, 2, 2, 'Ready for discharge tomorrow', '2024-01-16 08:15:00'),
(3, 4, 3, 1, 'Patient discharged', '2024-01-16 08:30:00');

-- Sample communications
INSERT INTO communications (location_id, from_user_id, to_user_id, patient_id, subject, message, priority, is_read) VALUES
(1, 2, 5, 1, 'Patient Care Update', 'Please monitor patient vitals every 2 hours', 'high', false),
(1, 4, 6, 2, 'Medication Adjustment', 'Please prepare new prescription for patient', 'normal', true),
(1, 8, 2, 3, 'Insurance Approval', 'Pre-authorization approved for patient treatment', 'normal', false),
(2, 3, 5, 4, 'Discharge Planning', 'Patient ready for discharge, prepare documents', 'normal', true);

-- Sample telecaller campaigns
INSERT INTO telecaller_campaigns (campaign_name, location_id, description, start_date, end_date, status, created_by) VALUES
('Appointment Reminders Jan 2024', 1, 'Monthly appointment reminder campaign', '2024-01-01', '2024-01-31', 'active', 9),
('Health Checkup Follow-up', 1, 'Follow-up with patients for annual checkups', '2024-01-15', '2024-02-15', 'active', 9),
('Payment Due Reminders', 2, 'Reminder calls for pending payments', '2024-01-10', '2024-01-25', 'completed', 9);

-- Sample telecaller follow-ups
INSERT INTO telecaller_followups (location_id, patient_id, telecaller_id, campaign_id, follow_up_type, scheduled_date, completed_date, status, notes, outcome) VALUES
(1, 1, 9, 1, 'appointment_reminder', '2024-01-14 10:00:00', '2024-01-14 10:15:00', 'completed', 'Reminded about cardiac follow-up', 'Patient confirmed appointment'),
(1, 2, 9, 2, 'health_checkup', '2024-01-16 14:00:00', '2024-01-16 14:10:00', 'completed', 'Annual checkup reminder', 'Patient scheduled appointment'),
(2, 4, 9, 3, 'payment_due', '2024-01-15 11:00:00', '2024-01-15 11:05:00', 'completed', 'Payment reminder call', 'Patient made payment'),
(1, 3, 9, 1, 'appointment_reminder', '2024-01-17 15:00:00', NULL, 'pending', 'Scheduled reminder call', NULL);

-- Sample patient queue
INSERT INTO patient_queue (location_id, patient_id, appointment_id, queue_number, queue_type, status, estimated_time, actual_time) VALUES
(1, 1, 1, 1, 'consultation', 'completed', '2024-01-15 09:00:00', '2024-01-15 09:15:00'),
(1, 2, 2, 2, 'consultation', 'completed', '2024-01-15 10:30:00', '2024-01-15 10:45:00'),
(1, 3, 3, 1, 'consultation', 'waiting', '2024-01-16 14:00:00', NULL),
(2, 4, 4, 1, 'consultation', 'completed', '2024-01-16 11:00:00', '2024-01-16 11:20:00'),
(1, 5, 5, 1, 'consultation', 'in_progress', '2024-01-17 15:30:00', '2024-01-17 15:35:00');

-- Sample system settings
INSERT INTO system_settings (location_id, setting_key, setting_value, description, updated_by) VALUES
(1, 'appointment_slot_duration', '30', 'Default appointment slot duration in minutes', 1),
(1, 'max_appointments_per_day', '50', 'Maximum appointments per doctor per day', 1),
(1, 'auto_generate_patient_id', 'true', 'Automatically generate patient IDs', 1),
(1, 'default_consultation_fee', '500', 'Default consultation fee amount', 1),
(1, 'enable_sms_reminders', 'true', 'Enable SMS appointment reminders', 1),
(2, 'appointment_slot_duration', '30', 'Default appointment slot duration in minutes', 1),
(2, 'max_appointments_per_day', '40', 'Maximum appointments per doctor per day', 1),
(2, 'default_consultation_fee', '450', 'Default consultation fee amount', 1);
-- Additional sample data for extended tables

-- Sample central pharmacy items
INSERT INTO central_pharmacy_items (item_code, location_id, name, generic_name, manufacturer, category, unit_price, stock_quantity, min_stock_level, max_stock_level, expiry_date, batch_number, rack_location) VALUES
('CPI001', 1, 'Paracetamol 500mg Bulk', 'Paracetamol', 'PharmaCorp', 'Analgesic', 2.00, 5000, 500, 10000, '2025-12-31', 'CBATCH001', 'A1-01'),
('CPI002', 1, 'Amoxicillin 250mg Bulk', 'Amoxicillin', 'MediLab', 'Antibiotic', 12.50, 2000, 200, 5000, '2025-06-30', 'CBATCH002', 'A1-02'),
('CPI003', 1, 'Metformin 500mg Bulk', 'Metformin HCl', 'DiabetCare', 'Antidiabetic', 6.75, 3000, 300, 8000, '2025-09-15', 'CBATCH003', 'A2-01'),
('CPI004', 1, 'Insulin Regular Bulk', 'Human Insulin', 'Novo Nordisk', 'Antidiabetic', 320.00, 200, 20, 500, '2025-06-25', 'CBATCH004', 'B1-01');

-- Sample pharmacy indents
INSERT INTO pharmacy_indents (indent_number, location_id, requested_by, approved_by, status, total_amount, request_date, required_date, notes) VALUES
('IND000001', 1, 6, 11, 'approved', 15000.00, '2024-01-10', '2024-01-15', 'Monthly stock replenishment'),
('IND000002', 2, 6, 11, 'ordered', 8000.00, '2024-01-12', '2024-01-18', 'Emergency stock requirement'),
('IND000003', 1, 6, NULL, 'pending', 12000.00, '2024-01-16', '2024-01-22', 'Routine stock indent');

-- Sample pharmacy indent items
INSERT INTO pharmacy_indent_items (indent_id, item_id, requested_quantity, approved_quantity, unit_price, total_price) VALUES
(1, 1, 500, 500, 2.00, 1000.00), (1, 2, 300, 300, 12.50, 3750.00), (1, 3, 400, 400, 6.75, 2700.00),
(2, 1, 200, 200, 2.00, 400.00), (2, 2, 150, 150, 12.50, 1875.00),
(3, 1, 600, 0, 2.00, 1200.00), (3, 4, 100, 0, 320.00, 32000.00);

-- Sample RFQ
INSERT INTO rfq (rfq_number, location_id, title, description, issue_date, submission_deadline, status, created_by) VALUES
('RFQ000001', 1, 'Medical Equipment Purchase', 'Purchase of various medical equipment for hospital', '2024-01-10', '2024-01-20', 'closed', 11),
('RFQ000002', 1, 'Pharmaceutical Supplies', 'Bulk purchase of pharmaceutical items', '2024-01-15', '2024-01-25', 'issued', 11);

-- Sample RFQ items
INSERT INTO rfq_items (rfq_id, item_description, quantity, unit, specifications) VALUES
(1, 'Digital Blood Pressure Monitor', 10, 'Piece', 'Automatic, with memory function'),
(1, 'Pulse Oximeter', 15, 'Piece', 'Finger type, LED display'),
(2, 'Paracetamol 500mg tablets', 10000, 'Tablets', 'WHO GMP certified'),
(2, 'Amoxicillin 250mg capsules', 5000, 'Capsules', 'Blister packed');

-- Sample RFQ responses
INSERT INTO rfq_responses (rfq_id, vendor_id, total_amount, submission_date, validity_days, terms_conditions, status) VALUES
(1, 2, 25000.00, '2024-01-18 14:00:00', 30, 'Payment within 30 days, 1 year warranty', 'accepted'),
(1, 5, 28000.00, '2024-01-19 10:00:00', 45, 'Payment within 45 days, 2 year warranty', 'rejected'),
(2, 3, 180000.00, '2024-01-22 16:00:00', 30, 'Payment within 30 days, quality guarantee', 'submitted');

-- Sample RFQ response items
INSERT INTO rfq_response_items (response_id, rfq_item_id, unit_price, total_price, delivery_days, brand) VALUES
(1, 1, 1500.00, 15000.00, 15, 'Omron'),
(1, 2, 800.00, 12000.00, 10, 'Nellcor'),
(2, 1, 1800.00, 18000.00, 20, 'Philips'),
(2, 2, 900.00, 13500.00, 15, 'Masimo'),
(3, 3, 0.15, 1500.00, 30, 'Generic'),
(3, 4, 0.35, 1750.00, 30, 'Generic');

-- Sample contracts
INSERT INTO contracts (contract_number, location_id, vendor_id, title, description, contract_value, start_date, end_date, status, terms_conditions, created_by) VALUES
('CON000001', 1, 1, 'Annual Medical Supply Contract', 'Annual contract for medical supplies', 500000.00, '2024-01-01', '2024-12-31', 'active', 'Monthly delivery, 30 days payment terms', 11),
('CON000002', 1, 2, 'Equipment Maintenance Contract', 'Annual maintenance contract for medical equipment', 120000.00, '2024-01-01', '2024-12-31', 'active', 'Quarterly maintenance, emergency support', 11);

-- Sample material schemes
INSERT INTO material_schemes (scheme_code, location_id, name, description, scheme_type, value, min_order_value, valid_from, valid_to) VALUES
('SCH001', 1, 'Bulk Purchase Discount', '10% discount on orders above 50000', 'discount', 10.00, 50000.00, '2024-01-01', '2024-12-31'),
('SCH002', 1, 'Free Goods Scheme', 'Buy 10 get 1 free on selected items', 'free_goods', 1.00, 1000.00, '2024-01-01', '2024-06-30'),
('SCH003', 1, 'Early Payment Cashback', '2% cashback for payments within 15 days', 'cashback', 2.00, 10000.00, '2024-01-01', '2024-12-31');

-- Sample AI insights
INSERT INTO ai_insights (location_id, insight_type, title, description, recommendations, confidence_score, generated_at, is_acknowledged, acknowledged_by) VALUES
(1, 'inventory_optimization', 'Low Stock Alert', 'Several items are running low and need reordering', '{"items": ["Surgical Gloves", "Syringes"], "action": "Place order within 3 days"}', 0.95, '2024-01-16 08:00:00', false, NULL),
(1, 'demand_forecast', 'Increased Demand Prediction', 'Paracetamol demand expected to increase by 20% next month', '{"item": "Paracetamol", "increase": "20%", "action": "Increase stock by 500 units"}', 0.87, '2024-01-16 09:00:00', true, 11),
(1, 'cost_analysis', 'Vendor Cost Comparison', 'Vendor B offers 15% better rates for medical supplies', '{"current_vendor": "Vendor A", "recommended_vendor": "Vendor B", "savings": "15%"}', 0.92, '2024-01-16 10:00:00', false, NULL);

-- Sample patient portal access
INSERT INTO patient_portal_access (patient_id, username, password, is_active, last_login) VALUES
(1, 'james.wilson', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', true, '2024-01-16 10:30:00'),
(2, 'maria.garcia', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', true, '2024-01-15 14:20:00'),
(3, 'jennifer.brown', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', true, NULL),
(5, 'sarah.thompson', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', true, '2024-01-14 16:45:00');

-- Sample patient health records
INSERT INTO patient_health_records (patient_id, record_type, title, description, date_recorded, doctor_id, is_visible_to_patient) VALUES
(1, 'condition', 'Hypertension', 'Diagnosed with essential hypertension', '2023-06-15', 2, true),
(1, 'medication', 'Lisinopril', 'Started on Lisinopril 10mg daily', '2023-06-15', 2, true),
(2, 'condition', 'Type 2 Diabetes', 'Diagnosed with Type 2 Diabetes Mellitus', '2022-03-20', 4, true),
(2, 'medication', 'Metformin', 'Started on Metformin 500mg twice daily', '2022-03-20', 4, true),
(3, 'allergy', 'Shellfish Allergy', 'Severe allergic reaction to shellfish', '2020-08-10', 2, true),
(5, 'condition', 'Migraine', 'Chronic migraine with aura', '2021-11-05', 4, true);

-- Sample patient support tickets
INSERT INTO patient_support_tickets (ticket_number, patient_id, location_id, subject, description, priority, status, assigned_to) VALUES
('TKT000001', 1, 1, 'Appointment Rescheduling', 'Need to reschedule my cardiac follow-up appointment', 'medium', 'resolved', 8),
('TKT000002', 2, 1, 'Lab Report Query', 'Unable to access my latest lab reports online', 'low', 'open', 8),
('TKT000003', 5, 1, 'Billing Inquiry', 'Question about insurance coverage on recent bill', 'high', 'in_progress', 10),
('TKT000004', 3, 1, 'Prescription Refill', 'Need refill for blood pressure medication', 'medium', 'resolved', 6);

-- Sample estimates
INSERT INTO estimates (estimate_number, location_id, patient_id, patient_name, patient_phone, total_amount, discount_amount, net_amount, valid_until, status, created_by) VALUES
('EST000001', 1, NULL, 'John Doe', '9123456700', 5000.00, 500.00, 4500.00, '2024-01-30', 'sent', 8),
('EST000002', 1, 3, 'Jennifer Brown', '9123456786', 8000.00, 800.00, 7200.00, '2024-02-15', 'accepted', 8),
('EST000003', 2, NULL, 'Mike Johnson', '9123456701', 3500.00, 0.00, 3500.00, '2024-01-25', 'draft', 8);

-- Sample estimate items
INSERT INTO estimate_items (estimate_id, item_name, item_code, quantity, unit_price, total_price, category) VALUES
(1, 'Cardiac Screening Package', 'PKG002', 1, 5000.00, 5000.00, 'Package'),
(2, 'Minor Surgery', 'SRV012', 1, 8000.00, 8000.00, 'Surgery'),
(3, 'General Consultation', 'SRV001', 1, 450.00, 450.00, 'Consultation'),
(3, 'X-Ray', 'SRV004', 1, 350.00, 350.00, 'Radiology'),
(3, 'Blood Test', 'SRV005', 1, 230.00, 230.00, 'Laboratory');

-- Sample investigations
INSERT INTO investigations (investigation_number, location_id, patient_id, doctor_id, investigation_type, title, description, status, scheduled_date, completed_date, findings) VALUES
('INV000001', 1, 1, 2, 'radiology', 'Chest X-Ray', 'Chest X-ray for cardiac assessment', 'completed', '2024-01-15 11:00:00', '2024-01-15 11:30:00', 'Mild cardiomegaly noted'),
('INV000002', 1, 2, 4, 'pathology', 'Diabetic Screening', 'Comprehensive diabetic workup', 'completed', '2024-01-15 12:00:00', '2024-01-15 16:00:00', 'HbA1c within target range'),
('INV000003', 1, 5, 4, 'radiology', 'Brain MRI', 'MRI for severe headache evaluation', 'scheduled', '2024-01-18 10:00:00', NULL, NULL);

-- Sample shifts
INSERT INTO shifts (shift_name, location_id, start_time, end_time) VALUES
('Morning Shift', 1, '06:00:00', '14:00:00'),
('Evening Shift', 1, '14:00:00', '22:00:00'),
('Night Shift', 1, '22:00:00', '06:00:00'),
('Day Shift', 2, '08:00:00', '20:00:00'),
('Night Shift', 2, '20:00:00', '08:00:00');

-- Sample user shifts
INSERT INTO user_shifts (user_id, shift_id, shift_date, check_in_time, check_out_time, status, notes) VALUES
(5, 1, '2024-01-15', '2024-01-15 06:00:00', '2024-01-15 14:00:00', 'checked_out', 'Regular shift'),
(5, 2, '2024-01-16', '2024-01-16 14:00:00', '2024-01-16 22:00:00', 'checked_out', 'Regular shift'),
(6, 1, '2024-01-15', '2024-01-15 06:15:00', '2024-01-15 14:10:00', 'checked_out', 'Slightly late'),
(7, 2, '2024-01-16', '2024-01-16 14:00:00', NULL, 'checked_in', 'Current shift');

-- Sample advance collections
INSERT INTO advance_collections (receipt_number, location_id, patient_id, admission_id, amount, payment_method, collected_by, purpose) VALUES
('ADV000001', 1, 1, 1, 10000.00, 'card', 10, 'ICU admission advance'),
('ADV000002', 1, 3, 2, 5000.00, 'cash', 10, 'Treatment advance'),
('ADV000003', 1, 5, 4, 3000.00, 'upi', 10, 'Emergency treatment advance');

-- Sample inpatient census
INSERT INTO inpatient_census (location_id, census_date, total_beds, occupied_beds, available_beds, admissions_today, discharges_today, transfers_in, transfers_out, occupancy_rate) VALUES
(1, '2024-01-15', 14, 8, 6, 2, 1, 0, 0, 57.14),
(1, '2024-01-16', 14, 10, 4, 3, 1, 1, 0, 71.43),
(2, '2024-01-15', 6, 3, 3, 1, 0, 0, 0, 50.00),
(2, '2024-01-16', 6, 2, 4, 0, 1, 0, 0, 33.33);

-- Sample patient transfers
INSERT INTO patient_transfers (transfer_number, patient_id, from_location_id, to_location_id, from_bed_id, to_bed_id, transfer_date, reason, status, transferred_by, received_by) VALUES
('PTR000001', 4, 2, 1, 17, 5, '2024-01-16 15:00:00', 'Specialist consultation required', 'completed', 3, 5);

-- Sample billing accounts
INSERT INTO billing_accounts (account_code, location_id, account_name, account_type, parent_account_id) VALUES
('ACC001', 1, 'Patient Revenue', 'revenue', NULL),
('ACC002', 1, 'Consultation Revenue', 'revenue', 1),
('ACC003', 1, 'Pharmacy Revenue', 'revenue', 1),
('ACC004', 1, 'Lab Revenue', 'revenue', 1),
('ACC005', 1, 'Medical Expenses', 'expense', NULL),
('ACC006', 1, 'Staff Salaries', 'expense', 5),
('ACC007', 1, 'Equipment Expenses', 'expense', 5);

-- Sample price lists
INSERT INTO price_lists (price_list_code, location_id, name, description, effective_from, effective_to, is_default) VALUES
('PL001', 1, 'Standard Price List', 'Standard pricing for all services', '2024-01-01', '2024-12-31', true),
('PL002', 1, 'Insurance Price List', 'Special pricing for insurance patients', '2024-01-01', '2024-12-31', false),
('PL003', 2, 'Branch Standard Pricing', 'Standard pricing for branch location', '2024-01-01', '2024-12-31', true);

-- Sample price list items
INSERT INTO price_list_items (price_list_id, service_id, price) VALUES
(1, 1, 500.00), (1, 2, 800.00), (1, 3, 300.00), (1, 4, 400.00), (1, 5, 250.00),
(2, 1, 400.00), (2, 2, 640.00), (2, 3, 240.00), (2, 4, 320.00), (2, 5, 200.00),
(3, 16, 450.00), (3, 17, 600.00), (3, 18, 280.00), (3, 19, 350.00), (3, 20, 230.00);

-- Sample cashier transactions
INSERT INTO cashier_transactions (transaction_number, location_id, cashier_id, transaction_type, amount, payment_method, reference_number, bill_id, patient_id) VALUES
('TXN000001', 1, 10, 'payment', 1150.00, 'card', 'CARD123456', 1, 1),
('TXN000002', 1, 10, 'payment', 862.50, 'cash', NULL, 2, 2),
('TXN000003', 1, 10, 'advance', 10000.00, 'card', 'CARD789012', NULL, 1),
('TXN000004', 2, 10, 'payment', 859.05, 'insurance', 'INS987654', 4, 4),
('TXN000005', 1, 10, 'refund', 100.00, 'cash', NULL, 1, 1);

-- Sample quick bills
INSERT INTO quick_bills (quick_bill_number, location_id, patient_name, patient_phone, total_amount, paid_amount, payment_method, created_by) VALUES
('QB000001', 1, 'Walk-in Patient 1', '9123456799', 150.00, 150.00, 'cash', 8),
('QB000002', 1, 'Emergency Patient', '9123456798', 500.00, 500.00, 'card', 8),
('QB000003', 2, 'Quick Consultation', '9123456797', 450.00, 450.00, 'upi', 8);

-- Sample quick bill items
INSERT INTO quick_bill_items (quick_bill_id, item_name, quantity, unit_price, total_price) VALUES
(1, 'Dressing', 1, 150.00, 150.00),
(2, 'Emergency Consultation', 1, 500.00, 500.00),
(3, 'General Consultation', 1, 450.00, 450.00);

-- End of comprehensive sample data