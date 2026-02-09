-- Fix master tables by dropping and recreating them
-- Database: hims_patient_management

\c hims_patient_management;

-- Drop existing master tables if they exist
DROP TABLE IF EXISTS patient_category CASCADE;
DROP TABLE IF EXISTS visit_type CASCADE;
DROP TABLE IF EXISTS consultation_type CASCADE;
DROP TABLE IF EXISTS marital_status CASCADE;
DROP TABLE IF EXISTS blood_group CASCADE;
DROP TABLE IF EXISTS gender CASCADE;

-- Recreate master tables with proper structure
-- Gender Master Table
CREATE TABLE gender (
    id SERIAL PRIMARY KEY,
    code VARCHAR(10) UNIQUE NOT NULL,
    name VARCHAR(20) NOT NULL,
    description VARCHAR(100),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Blood Group Master Table
CREATE TABLE blood_group (
    id SERIAL PRIMARY KEY,
    code VARCHAR(5) UNIQUE NOT NULL,
    name VARCHAR(10) NOT NULL,
    description VARCHAR(50),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Marital Status Master Table
CREATE TABLE marital_status (
    id SERIAL PRIMARY KEY,
    code VARCHAR(10) UNIQUE NOT NULL,
    name VARCHAR(20) NOT NULL,
    description VARCHAR(100),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Consultation Type Master Table
CREATE TABLE consultation_type (
    id SERIAL PRIMARY KEY,
    code VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(200),
    fee_amount DECIMAL(10,2) DEFAULT 0.00,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Visit Type Master Table
CREATE TABLE visit_type (
    id SERIAL PRIMARY KEY,
    code VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(200),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Patient Category Master Table
CREATE TABLE patient_category (
    id SERIAL PRIMARY KEY,
    code VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(200),
    requires_company_details BOOLEAN DEFAULT false,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert default data for Gender Master
INSERT INTO gender (code, name, description) VALUES
('M', 'Male', 'Male gender'),
('F', 'Female', 'Female gender'),
('O', 'Other', 'Other gender');

-- Insert default data for Blood Group Master
INSERT INTO blood_group (code, name, description) VALUES
('A+', 'A+', 'A positive blood group'),
('A-', 'A-', 'A negative blood group'),
('B+', 'B+', 'B positive blood group'),
('B-', 'B-', 'B negative blood group'),
('AB+', 'AB+', 'AB positive blood group'),
('AB-', 'AB-', 'AB negative blood group'),
('O+', 'O+', 'O positive blood group'),
('O-', 'O-', 'O negative blood group');

-- Insert default data for Marital Status Master
INSERT INTO marital_status (code, name, description) VALUES
('S', 'Single', 'Single'),
('M', 'Married', 'Married'),
('D', 'Divorced', 'Divorced'),
('W', 'Widowed', 'Widowed');

-- Insert default data for Consultation Type Master
INSERT INTO consultation_type (code, name, description, fee_amount) VALUES
('NORMAL', 'Normal Consultation', 'Regular consultation with doctor', 500.00),
('EMERGENCY', 'Emergency Consultation', 'Emergency medical consultation', 1000.00),
('FOLLOWUP', 'Follow-up Consultation', 'Follow-up visit consultation', 300.00),
('SELECT', 'Cons Select', 'Consultation selection type', 0.00);

-- Insert default data for Visit Type Master
INSERT INTO visit_type (code, name, description) VALUES
('NEW', 'New Client', 'First time patient visit'),
('REVISIT', 'Revisit', 'Return patient visit'),
('FOLLOWUP', 'Follow-up', 'Follow-up appointment');

-- Insert default data for Patient Category Master
INSERT INTO patient_category (code, name, description, requires_company_details) VALUES
('PAYING', 'Paying', 'Self-paying patient', false),
('CREDIT_COMPANY', 'Credit Company', 'Company sponsored patient', true);

-- Create indexes for better performance
CREATE INDEX idx_gender_code ON gender(code);
CREATE INDEX idx_blood_group_code ON blood_group(code);
CREATE INDEX idx_marital_status_code ON marital_status(code);
CREATE INDEX idx_consultation_type_code ON consultation_type(code);
CREATE INDEX idx_visit_type_code ON visit_type(code);
CREATE INDEX idx_patient_category_code ON patient_category(code);