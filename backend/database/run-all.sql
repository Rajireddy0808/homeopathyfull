-- Complete HIMS Database Setup
-- Run this single file to create all tables and insert all sample data

-- COMPLETE HIMS Database Schema
-- PostgreSQL Database Structure for ALL Frontend Modules

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

-- Users table for authentication and authorization
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

-- Beds table for inpatient management
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

-- Insurance claims table
CREATE TABLE insurance_claims (
    id SERIAL PRIMARY KEY,
    claim_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    patient_id INTEGER NOT NULL REFERENCES patients(id),
    insurance_company_id INTEGER NOT NULL REFERENCES insurance_companies(id),
    bill_id INTEGER REFERENCES bills(id),
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

-- Vendors table for material management
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

-- Create indexes for better performance
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

-- NOW INSERT SAMPLE DATA

-- Insert sample locations
INSERT INTO locations (location_code, name, address, phone, email) VALUES
('LOC001', 'Main Hospital', '123 Hospital Street, City Center, State 12345', '9876543200', 'main@hospital.com'),
('LOC002', 'Branch Clinic North', '456 North Avenue, North District, State 12346', '9876543201', 'north@hospital.com'),
('LOC003', 'Branch Clinic South', '789 South Road, South District, State 12347', '9876543202', 'south@hospital.com');

-- Insert sample users with location references
INSERT INTO users (username, email, password, first_name, last_name, role, location_id, phone, department, specialization, license_number) VALUES
('admin', 'admin@hospital.com', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', 'Admin', 'User', 'admin', 1, '9876543210', 'Administration', NULL, NULL),
('dr.smith', 'dr.smith@hospital.com', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', 'John', 'Smith', 'doctor', 1, '9876543211', 'Cardiology', 'Interventional Cardiology', 'DOC001'),
('dr.johnson', 'dr.johnson@hospital.com', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', 'Sarah', 'Johnson', 'doctor', 2, '9876543212', 'Pediatrics', 'Child Development', 'DOC002'),
('dr.williams', 'dr.williams@hospital.com', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', 'Michael', 'Williams', 'doctor', 1, '9876543213', 'Orthopedics', 'Joint Replacement', 'DOC003'),
('nurse.mary', 'nurse.mary@hospital.com', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', 'Mary', 'Wilson', 'nurse', 1, '9876543214', 'General Ward', NULL, 'NUR001'),
('pharmacist.bob', 'pharmacist.bob@hospital.com', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', 'Bob', 'Anderson', 'pharmacist', 1, '9876543215', 'Pharmacy', NULL, 'PHA001'),
('lab.tech', 'lab.tech@hospital.com', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', 'Lisa', 'Brown', 'lab_technician', 1, '9876543216', 'Laboratory', NULL, 'LAB001'),
('front.desk', 'front.desk@hospital.com', '$2b$10$rOzJqQjQjQjQjQjQjQjO', 'Emma', 'Davis', 'front_office', 1, '9876543217', 'Front Office', NULL, NULL),
('telecaller1', 'telecaller1@hospital.com', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', 'Mike', 'Taylor', 'telecaller', 1, '9876543218', 'Customer Service', NULL, NULL),
('billing.clerk', 'billing.clerk@hospital.com', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', 'Anna', 'Miller', 'billing', 1, '9876543219', 'Billing', NULL, NULL),
('material.mgr', 'material.mgr@hospital.com', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', 'David', 'Garcia', 'material_manager', 1, '9876543220', 'Material Management', NULL, NULL);

-- Insert sample patients
INSERT INTO patients (patient_id, location_id, first_name, last_name, date_of_birth, gender, phone, email, address, emergency_contact, blood_group, allergies, medical_history, insurance_number) VALUES
('PAT000001', 1, 'James', 'Wilson', '1985-03-15', 'male', '9123456789', 'james.wilson@email.com', '123 Main St, City, State 12345', '9123456790', 'O+', 'Penicillin allergy', 'Hypertension, Diabetes Type 2', 'INS001234567'),
('PAT000002', 1, 'Maria', 'Garcia', '1990-07-22', 'female', '9123456788', 'maria.garcia@email.com', '456 Oak Ave, City, State 12345', '9123456791', 'A+', 'None known', 'Asthma', 'INS001234568'),
('PAT000001', 2, 'Robert', 'Johnson', '1978-11-08', 'male', '9123456787', 'robert.johnson@email.com', '789 Pine St, North District, State 12346', '9123456792', 'B+', 'Shellfish allergy', 'Heart disease family history', NULL),
('PAT000003', 1, 'Jennifer', 'Brown', '1995-05-12', 'female', '9123456786', 'jennifer.brown@email.com', '321 Elm St, City, State 12345', '9123456793', 'AB+', 'Latex allergy', 'None significant', NULL),
('PAT000004', 1, 'Michael', 'Davis', '1982-09-30', 'male', '9123456785', 'michael.davis@email.com', '654 Maple Ave, City, State 12345', '9123456794', 'O-', 'None known', 'Migraine history', 'INS001234570');

-- Insert sample services
INSERT INTO services (service_code, location_id, name, category, price, description) VALUES
('SRV001', 1, 'General Consultation', 'Consultation', 500.00, 'General physician consultation'),
('SRV002', 1, 'Cardiology Consultation', 'Consultation', 800.00, 'Specialist cardiology consultation'),
('SRV003', 1, 'ECG', 'Diagnostic', 300.00, 'Electrocardiogram test'),
('SRV004', 1, 'X-Ray Chest', 'Radiology', 400.00, 'Chest X-ray examination'),
('SRV005', 1, 'Blood Test', 'Laboratory', 250.00, 'Complete blood count test');

-- Insert sample packages
INSERT INTO packages (package_code, location_id, name, description, total_price, discounted_price) VALUES
('PKG001', 1, 'Basic Health Checkup', 'Complete basic health screening package', 2500.00, 2000.00),
('PKG002', 1, 'Cardiac Screening', 'Comprehensive cardiac health package', 5000.00, 4200.00);

-- Insert sample package services
INSERT INTO package_services (package_id, service_id, quantity) VALUES
(1, 1, 1),
(1, 3, 1),
(1, 5, 1),
(2, 2, 1),
(2, 3, 1),
(2, 4, 1);

-- Insert sample discounts
INSERT INTO discounts (discount_code, location_id, name, type, value, min_amount, max_discount, valid_from, valid_to) VALUES
('SENIOR10', 1, 'Senior Citizen Discount', 'percentage', 10.00, 500.00, 1000.00, '2024-01-01', '2024-12-31'),
('STAFF20', 1, 'Staff Discount', 'percentage', 20.00, 100.00, 2000.00, '2024-01-01', '2024-12-31'),
('NEWPATIENT', 1, 'New Patient Discount', 'fixed', 100.00, 1000.00, 100.00, '2024-01-01', '2024-12-31');

-- Insert sample medicines
INSERT INTO medicines (medicine_code, location_id, name, generic_name, manufacturer, category, unit_price, stock_quantity, min_stock_level, expiry_date, batch_number) VALUES
('MED001', 1, 'Paracetamol 500mg', 'Paracetamol', 'PharmaCorp', 'Analgesic', 2.50, 1000, 100, '2025-12-31', 'BATCH001'),
('MED002', 1, 'Amoxicillin 250mg', 'Amoxicillin', 'MediLab', 'Antibiotic', 15.75, 500, 50, '2025-06-30', 'BATCH002'),
('MED003', 1, 'Metformin 500mg', 'Metformin HCl', 'DiabetCare', 'Antidiabetic', 8.25, 800, 80, '2025-09-15', 'BATCH003'),
('MED004', 1, 'Lisinopril 10mg', 'Lisinopril', 'CardioMed', 'ACE Inhibitor', 12.50, 300, 30, '2025-11-20', 'BATCH004'),
('MED005', 1, 'Omeprazole 20mg', 'Omeprazole', 'GastroPharm', 'PPI', 18.90, 400, 40, '2025-08-10', 'BATCH005'),
('MED006', 1, 'Aspirin 75mg', 'Aspirin', 'CardioMed', 'Antiplatelet', 3.50, 600, 60, '2025-10-15', 'BATCH006');

-- Insert sample lab tests
INSERT INTO lab_tests (test_code, location_id, test_name, category, price, normal_range, unit, sample_type) VALUES
('LAB001', 1, 'Complete Blood Count', 'Hematology', 250.00, 'Various parameters', 'Multiple', 'Blood'),
('LAB002', 1, 'Blood Glucose Fasting', 'Biochemistry', 150.00, '70-100', 'mg/dL', 'Blood'),
('LAB003', 1, 'Lipid Profile', 'Biochemistry', 400.00, 'Various parameters', 'mg/dL', 'Blood'),
('LAB004', 1, 'Thyroid Function Test', 'Endocrinology', 500.00, 'TSH: 0.4-4.0', 'mIU/L', 'Blood'),
('LAB005', 1, 'Liver Function Test', 'Biochemistry', 350.00, 'Various parameters', 'U/L', 'Blood'),
('LAB006', 1, 'Urine Routine', 'Pathology', 200.00, 'Normal', 'Various', 'Urine'),
('LAB007', 1, 'HbA1c', 'Biochemistry', 300.00, '4.0-5.6%', '%', 'Blood');

-- Insert sample beds
INSERT INTO beds (bed_number, location_id, ward, bed_type, price_per_day) VALUES
('ICU-001', 1, 'ICU', 'icu', 5000.00),
('ICU-002', 1, 'ICU', 'icu', 5000.00),
('GEN-001', 1, 'General Ward A', 'general', 1500.00),
('GEN-002', 1, 'General Ward A', 'general', 1500.00),
('GEN-003', 1, 'General Ward B', 'general', 1500.00),
('PVT-001', 1, 'Private Ward', 'private', 3000.00),
('PVT-002', 1, 'Private Ward', 'private', 3000.00),
('EMR-001', 1, 'Emergency', 'emergency', 2000.00),
('EMR-002', 1, 'Emergency', 'emergency', 2000.00),
('ICU-001', 2, 'ICU North', 'icu', 4500.00);

-- Insert sample insurance companies
INSERT INTO insurance_companies (name, code, contact_person, phone, email, address) VALUES
('National Health Insurance', 'NHI', 'John Manager', '9876543220', 'contact@nhi.com', '100 Insurance Plaza, City'),
('Star Health Insurance', 'STAR', 'Sarah Director', '9876543221', 'info@starhealth.com', '200 Health Tower, City'),
('HDFC ERGO Health', 'HDFC', 'Mike Executive', '9876543222', 'support@hdfcergo.com', '300 HDFC Building, City'),
('ICICI Lombard Health', 'ICICI', 'Lisa Coordinator', '9876543223', 'help@icicilombard.com', '400 ICICI Center, City');

-- Insert sample vendors
INSERT INTO vendors (vendor_code, location_id, name, contact_person, phone, email, address, gst_number, pan_number) VALUES
('VEN001', 1, 'MedSupply Corp', 'Alex Johnson', '9876543226', 'alex@medsupply.com', '700 Supply Street, City', 'GST123456789', 'PAN123456'),
('VEN002', 1, 'HealthEquip Ltd', 'Maria Rodriguez', '9876543227', 'maria@healthequip.com', '800 Equipment Ave, City', 'GST987654321', 'PAN987654'),
('VEN003', 1, 'PharmaDist Inc', 'Carlos Martinez', '9876543228', 'carlos@pharmadist.com', '900 Pharma Road, City', 'GST456789123', 'PAN456789');

-- Insert sample items
INSERT INTO items (item_code, location_id, name, category, unit, unit_price, stock_quantity, min_stock_level) VALUES
('ITM001', 1, 'Surgical Gloves', 'Medical Supplies', 'Box', 150.00, 500, 50),
('ITM002', 1, 'Syringes 5ml', 'Medical Supplies', 'Pack', 75.00, 1000, 100),
('ITM003', 1, 'Bandages', 'Medical Supplies', 'Roll', 25.00, 200, 20),
('ITM004', 1, 'Cotton Swabs', 'Medical Supplies', 'Pack', 30.00, 300, 30),
('ITM005', 1, 'Surgical Masks', 'Medical Supplies', 'Box', 120.00, 400, 40);

-- Insert sample appointments
INSERT INTO appointments (appointment_number, location_id, patient_id, doctor_id, appointment_date, type, status, reason, consultation_fee) VALUES
('APT000001', 1, 1, 2, '2024-01-15 10:00:00', 'consultation', 'completed', 'Regular checkup', 500.00),
('APT000002', 1, 2, 2, '2024-01-16 14:30:00', 'follow_up', 'scheduled', 'Diabetes follow-up', 300.00),
('APT000003', 1, 4, 4, '2024-01-17 09:00:00', 'consultation', 'confirmed', 'Joint pain consultation', 800.00),
('APT000001', 2, 3, 3, '2024-01-17 11:00:00', 'consultation', 'confirmed', 'Heart checkup', 800.00),
('APT000004', 1, 5, 2, '2024-01-18 15:00:00', 'routine_checkup', 'scheduled', 'Annual checkup', 500.00);

-- Insert sample vitals
INSERT INTO vitals (location_id, patient_id, appointment_id, recorded_by, height, weight, bmi, temperature, blood_pressure_systolic, blood_pressure_diastolic, pulse_rate, respiratory_rate, oxygen_saturation, blood_sugar, notes) VALUES
(1, 1, 1, 5, 175.5, 70.2, 22.8, 98.6, 120, 80, 72, 16, 98.5, 95.0, 'Normal vitals'),
(1, 2, 2, 5, 162.0, 58.5, 22.3, 98.4, 110, 70, 68, 18, 99.0, 140.0, 'Slightly elevated blood sugar'),
(1, 4, 3, 5, 168.0, 65.0, 23.0, 98.2, 125, 85, 75, 16, 98.8, 88.0, 'Normal vitals');

-- Insert sample prescriptions
INSERT INTO prescriptions (prescription_number, location_id, patient_id, doctor_id, appointment_id, status, notes) VALUES
('PRE000001', 1, 1, 2, 1, 'dispensed', 'Take medications as prescribed'),
('PRE000002', 1, 2, 2, 2, 'pending', 'Continue diabetes medication'),
('PRE000003', 1, 4, 4, 3, 'pending', 'Pain management for joint issues');

-- Insert prescription items
INSERT INTO prescription_items (prescription_id, medicine_id, quantity, dosage, frequency, duration, instructions) VALUES
(1, 1, 30, '500mg', 'Twice daily', 15, 'Take after meals'),
(1, 3, 20, '500mg', 'Once daily', 10, 'Take before breakfast'),
(2, 3, 60, '500mg', 'Twice daily', 30, 'Take with meals'),
(2, 6, 30, '75mg', 'Once daily', 30, 'Take in morning'),
(3, 1, 20, '500mg', 'As needed', 10, 'Take for pain relief');

-- Insert sample bills
INSERT INTO bills (bill_number, location_id, patient_id, appointment_id, total_amount, discount_amount, tax_amount, net_amount, paid_amount, status, payment_method, created_by) VALUES
('BILL000001', 1, 1, 1, 750.00, 50.00, 100.00, 800.00, 800.00, 'paid', 'card', 10),
('BILL000002', 1, 2, 2, 375.00, 0.00, 67.50, 442.50, 442.50, 'paid', 'cash', 10),
('BILL000003', 1, 4, 3, 850.00, 85.00, 137.70, 902.70, 0.00, 'pending', NULL, 10);

-- Insert bill items
INSERT INTO bill_items (bill_id, item_name, item_code, quantity, unit_price, total_price, category) VALUES
(1, 'Consultation Fee', 'SRV001', 1, 500.00, 500.00, 'Consultation'),
(1, 'Paracetamol 500mg', 'MED001', 30, 2.50, 75.00, 'Medicine'),
(1, 'Metformin 500mg', 'MED003', 20, 8.25, 165.00, 'Medicine'),
(2, 'Follow-up Consultation', 'SRV001', 1, 300.00, 300.00, 'Consultation'),
(2, 'Metformin 500mg', 'MED003', 60, 8.25, 75.00, 'Medicine'),
(3, 'Orthopedic Consultation', 'SRV002', 1, 800.00, 800.00, 'Consultation'),
(3, 'Paracetamol 500mg', 'MED001', 20, 2.50, 50.00, 'Medicine');

-- Insert sample lab orders
INSERT INTO lab_orders (order_number, location_id, patient_id, doctor_id, appointment_id, status, collection_date, report_date, notes) VALUES
('LAB000001', 1, 1, 2, 1, 'completed', '2024-01-15 09:00:00', '2024-01-15 18:00:00', 'Routine blood work'),
('LAB000002', 1, 2, 2, 2, 'completed', '2024-01-16 08:30:00', '2024-01-16 17:30:00', 'Diabetes monitoring'),
('LAB000003', 1, 4, 4, 3, 'ordered', NULL, NULL, 'Pre-treatment assessment');

-- Insert lab order items
INSERT INTO lab_order_items (order_id, test_id, result, status, remarks) VALUES
(1, 1, 'Normal', 'completed', 'All parameters within normal range'),
(1, 2, '85 mg/dL', 'completed', 'Within normal range'),
(2, 2, '145 mg/dL', 'completed', 'Slightly elevated'),
(2, 7, '7.2%', 'completed', 'Needs better control'),
(3, 1, NULL, 'pending', 'Sample collected'),
(3, 5, NULL, 'pending', 'Sample collected');

-- Insert sample admission
INSERT INTO admissions (admission_number, location_id, patient_id, bed_id, doctor_id, admission_date, status, admission_type, diagnosis, notes) VALUES
('ADM000001', 1, 4, 1, 2, '2024-01-10 15:30:00', 'admitted', 'emergency', 'Acute chest pain', 'Patient stable, monitoring required'),
('ADM000002', 1, 5, 6, 4, '2024-01-12 10:00:00', 'discharged', 'planned', 'Joint replacement surgery', 'Surgery completed successfully');

-- Update bed status
UPDATE beds SET status = 'occupied' WHERE id = 1;
UPDATE beds SET status = 'available' WHERE id = 6;

-- Insert sample purchase orders
INSERT INTO purchase_orders (po_number, location_id, vendor_id, total_amount, status, order_date, expected_delivery_date, created_by) VALUES
('PO000001', 1, 1, 15000.00, 'sent', '2024-01-10', '2024-01-20', 11),
('PO000002', 1, 2, 8500.00, 'received', '2024-01-05', '2024-01-15', 11);

-- Insert purchase order items
INSERT INTO purchase_order_items (po_id, item_id, quantity, unit_price, total_price) VALUES
(1, 1, 100, 150.00, 15000.00),
(2, 2, 50, 75.00, 3750.00),
(2, 3, 190, 25.00, 4750.00);

-- Insert sample insurance claims
INSERT INTO insurance_claims (claim_number, location_id, patient_id, insurance_company_id, bill_id, claim_amount, approved_amount, status, submission_date, approval_date, remarks) VALUES
('CLM000001', 1, 1, 1, 1, 800.00, 640.00, 'approved', '2024-01-16 10:00:00', '2024-01-18 15:00:00', 'Approved with 80% coverage'),
('CLM000002', 1, 2, 2, 2, 442.50, NULL, 'submitted', '2024-01-17 11:00:00', NULL, 'Under review');