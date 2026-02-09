-- Insurance Service Database Schema
-- Database: hims_insurance

CREATE DATABASE hims_insurance;
\c hims_insurance;

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
    service_id INTEGER,
    package_id INTEGER,
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
    patient_id INTEGER NOT NULL,
    insurance_company_id INTEGER NOT NULL REFERENCES insurance_companies(id),
    requested_amount DECIMAL(10,2) NOT NULL,
    approved_amount DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected', 'expired')),
    valid_from DATE,
    valid_to DATE,
    diagnosis TEXT,
    treatment_plan TEXT,
    created_by INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(auth_number, location_id)
);

-- Insurance claims table
CREATE TABLE insurance_claims (
    id SERIAL PRIMARY KEY,
    claim_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    patient_id INTEGER NOT NULL,
    insurance_company_id INTEGER NOT NULL REFERENCES insurance_companies(id),
    bill_id INTEGER,
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

-- Insurance policies table
CREATE TABLE insurance_policies (
    id SERIAL PRIMARY KEY,
    policy_number VARCHAR(50) NOT NULL,
    patient_id INTEGER NOT NULL,
    insurance_company_id INTEGER NOT NULL REFERENCES insurance_companies(id),
    tpa_company_id INTEGER REFERENCES tpa_companies(id),
    policy_holder_name VARCHAR(100) NOT NULL,
    relationship VARCHAR(20) CHECK (relationship IN ('self', 'spouse', 'child', 'parent', 'other')),
    sum_insured DECIMAL(12,2) NOT NULL,
    policy_start_date DATE NOT NULL,
    policy_end_date DATE NOT NULL,
    premium_amount DECIMAL(10,2),
    deductible_amount DECIMAL(10,2) DEFAULT 0,
    co_payment_percentage DECIMAL(5,2) DEFAULT 0,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'expired', 'cancelled', 'suspended')),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(policy_number, insurance_company_id)
);

-- Insurance claim documents table
CREATE TABLE insurance_claim_documents (
    id SERIAL PRIMARY KEY,
    claim_id INTEGER NOT NULL REFERENCES insurance_claims(id) ON DELETE CASCADE,
    document_type VARCHAR(50) NOT NULL CHECK (document_type IN ('bill', 'prescription', 'lab_report', 'discharge_summary', 'medical_certificate', 'other')),
    document_name VARCHAR(200) NOT NULL,
    document_url VARCHAR(500) NOT NULL,
    file_size INTEGER,
    uploaded_by INTEGER NOT NULL,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insurance eligibility checks table
CREATE TABLE insurance_eligibility_checks (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER NOT NULL,
    insurance_company_id INTEGER NOT NULL REFERENCES insurance_companies(id),
    policy_number VARCHAR(50) NOT NULL,
    check_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    eligibility_status VARCHAR(20) CHECK (eligibility_status IN ('eligible', 'not_eligible', 'pending', 'expired')),
    available_balance DECIMAL(12,2),
    utilized_amount DECIMAL(12,2),
    response_data JSONB,
    checked_by INTEGER NOT NULL,
    remarks TEXT
);

-- Indexes
CREATE INDEX idx_insurance_rates_location ON insurance_rates(location_id);
CREATE INDEX idx_insurance_rates_company ON insurance_rates(insurance_company_id);
CREATE INDEX idx_pre_authorizations_location ON pre_authorizations(location_id);
CREATE INDEX idx_pre_authorizations_patient ON pre_authorizations(patient_id);
CREATE INDEX idx_pre_authorizations_company ON pre_authorizations(insurance_company_id);
CREATE INDEX idx_insurance_claims_location ON insurance_claims(location_id);
CREATE INDEX idx_insurance_claims_patient ON insurance_claims(patient_id);
CREATE INDEX idx_insurance_claims_company ON insurance_claims(insurance_company_id);
CREATE INDEX idx_insurance_policies_patient ON insurance_policies(patient_id);
CREATE INDEX idx_insurance_policies_company ON insurance_policies(insurance_company_id);
CREATE INDEX idx_insurance_claim_documents_claim ON insurance_claim_documents(claim_id);
CREATE INDEX idx_insurance_eligibility_checks_patient ON insurance_eligibility_checks(patient_id);