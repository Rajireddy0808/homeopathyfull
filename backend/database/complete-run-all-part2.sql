-- Additional tables for complete frontend coverage

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
CREATE INDEX idx_communications_location ON communications(location_id);