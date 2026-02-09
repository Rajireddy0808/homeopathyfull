-- Menu System Setup
-- Create menus table for dynamic sidebar

CREATE TABLE IF NOT EXISTS menus (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    code VARCHAR(50) NOT NULL UNIQUE,
    href VARCHAR(200),
    icon VARCHAR(50),
    sort_order INTEGER DEFAULT 0,
    parent_id INTEGER REFERENCES menus(id) ON DELETE CASCADE,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS role_menus (
    id SERIAL PRIMARY KEY,
    role_id INTEGER NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    menu_id INTEGER NOT NULL REFERENCES menus(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(role_id, menu_id)
);

-- Insert main modules
INSERT INTO menus (title, code, href, icon, sort_order) VALUES
('Dashboard', 'DASHBOARD', '/dashboard', 'Home', 1),
('Front Office', 'FRONT_OFFICE', NULL, 'Users', 2),
('Patient Portal', 'PATIENT_PORTAL', NULL, 'User', 3),
('Material Management', 'MATERIAL_MGMT', NULL, 'Package', 4),
('Patients', 'PATIENTS', NULL, 'Users', 5),
('Telecaller/CRM', 'TELECALLER', NULL, 'Phone', 6),
('Doctors Module', 'DOCTORS', NULL, 'Stethoscope', 7),
('Queue Management', 'QUEUE', '/queue', 'Calendar', 8),
('Vitals', 'VITALS', NULL, 'BarChart3', 9),
('Prescriptions', 'PRESCRIPTIONS', NULL, 'FileText', 10),
('Pharmacy', 'PHARMACY', NULL, 'Pill', 11),
('Central Pharmacy', 'CENTRAL_PHARMACY', NULL, 'Building', 12),
('Laboratory', 'LABORATORY', NULL, 'TestTube', 13),
('Inpatient', 'INPATIENT', NULL, 'Bed', 14),
('Insurance & TPA', 'INSURANCE', NULL, 'Shield', 15),
('Billing', 'BILLING', NULL, 'CreditCard', 16),
('Settings', 'SETTINGS', '/settings', 'UserCog', 17)
ON CONFLICT (code) DO NOTHING;

-- Insert Front Office submenus
INSERT INTO menus (title, code, href, icon, sort_order, parent_id) VALUES
('Dashboard', 'FRONT_OFFICE_DASHBOARD', '/front-office', 'LayoutDashboard', 1, (SELECT id FROM menus WHERE code = 'FRONT_OFFICE')),
('Patient Registration', 'FRONT_OFFICE_REGISTRATION', '/front-office/registration', 'UserPlus', 2, (SELECT id FROM menus WHERE code = 'FRONT_OFFICE')),
('Appointments', 'FRONT_OFFICE_APPOINTMENTS', '/front-office/appointments', 'Calendar', 3, (SELECT id FROM menus WHERE code = 'FRONT_OFFICE')),
('OP Billing', 'FRONT_OFFICE_BILLING', '/front-office/billing', 'CreditCard', 4, (SELECT id FROM menus WHERE code = 'FRONT_OFFICE')),
('Adjustments & Credits', 'FRONT_OFFICE_ADJUSTMENTS', '/front-office/adjustments', 'Receipt', 5, (SELECT id FROM menus WHERE code = 'FRONT_OFFICE')),
('Estimates & Deposits', 'FRONT_OFFICE_ESTIMATES', '/front-office/estimates', 'Receipt', 6, (SELECT id FROM menus WHERE code = 'FRONT_OFFICE')),
('Investigations', 'FRONT_OFFICE_INVESTIGATIONS', '/front-office/investigations', 'TestTube', 7, (SELECT id FROM menus WHERE code = 'FRONT_OFFICE')),
('Payments & Receipts', 'FRONT_OFFICE_PAYMENTS', '/front-office/payments', 'IndianRupee', 8, (SELECT id FROM menus WHERE code = 'FRONT_OFFICE')),
('Due Bills', 'FRONT_OFFICE_DUE_BILLS', '/front-office/due-bills', 'AlertTriangle', 9, (SELECT id FROM menus WHERE code = 'FRONT_OFFICE')),
('Customer Service', 'FRONT_OFFICE_CUSTOMER_SERVICE', '/front-office/customer-service', 'Phone', 10, (SELECT id FROM menus WHERE code = 'FRONT_OFFICE')),
('Insurance Desk', 'FRONT_OFFICE_INSURANCE', '/front-office/insurance', 'Shield', 11, (SELECT id FROM menus WHERE code = 'FRONT_OFFICE')),
('Shift Management', 'FRONT_OFFICE_SHIFTS', '/front-office/shifts', 'Clock', 12, (SELECT id FROM menus WHERE code = 'FRONT_OFFICE')),
('Reports', 'FRONT_OFFICE_REPORTS', '/front-office/reports', 'BarChart3', 13, (SELECT id FROM menus WHERE code = 'FRONT_OFFICE'))
ON CONFLICT (code) DO NOTHING;

-- Insert Patient Portal submenus
INSERT INTO menus (title, code, href, icon, sort_order, parent_id) VALUES
('Portal Dashboard', 'PATIENT_PORTAL_DASHBOARD', '/patient-portal', 'LayoutDashboard', 1, (SELECT id FROM menus WHERE code = 'PATIENT_PORTAL')),
('My Appointments', 'PATIENT_PORTAL_APPOINTMENTS', '/patient-portal/appointments', 'Calendar', 2, (SELECT id FROM menus WHERE code = 'PATIENT_PORTAL')),
('Book Appointment', 'PATIENT_PORTAL_BOOK', '/patient-portal/appointments/book', 'Calendar', 3, (SELECT id FROM menus WHERE code = 'PATIENT_PORTAL')),
('Prescriptions', 'PATIENT_PORTAL_PRESCRIPTIONS', '/patient-portal/prescriptions', 'FileText', 4, (SELECT id FROM menus WHERE code = 'PATIENT_PORTAL')),
('Lab Reports', 'PATIENT_PORTAL_LAB_REPORTS', '/patient-portal/lab-reports', 'TestTube', 5, (SELECT id FROM menus WHERE code = 'PATIENT_PORTAL')),
('Bills & Payments', 'PATIENT_PORTAL_BILLS', '/patient-portal/bills', 'CreditCard', 6, (SELECT id FROM menus WHERE code = 'PATIENT_PORTAL')),
('Health History', 'PATIENT_PORTAL_HEALTH_HISTORY', '/patient-portal/health-history', 'BarChart3', 7, (SELECT id FROM menus WHERE code = 'PATIENT_PORTAL')),
('Support', 'PATIENT_PORTAL_SUPPORT', '/patient-portal/support', 'Phone', 8, (SELECT id FROM menus WHERE code = 'PATIENT_PORTAL'))
ON CONFLICT (code) DO NOTHING;

-- Insert Material Management submenus
INSERT INTO menus (title, code, href, icon, sort_order, parent_id) VALUES
('Dashboard', 'MATERIAL_MGMT_DASHBOARD', '/material-management', 'LayoutDashboard', 1, (SELECT id FROM menus WHERE code = 'MATERIAL_MGMT')),
('Masters & Catalogs', 'MATERIAL_MGMT_MASTERS', '/material-management/masters', 'Package', 2, (SELECT id FROM menus WHERE code = 'MATERIAL_MGMT')),
('Procurement', 'MATERIAL_MGMT_PROCUREMENT', '/material-management/procurement', 'ShoppingCart', 3, (SELECT id FROM menus WHERE code = 'MATERIAL_MGMT')),
('Inbound Operations', 'MATERIAL_MGMT_INBOUND', '/material-management/inbound', 'Truck', 4, (SELECT id FROM menus WHERE code = 'MATERIAL_MGMT')),
('Inventory Management', 'MATERIAL_MGMT_INVENTORY', '/material-management/inventory', 'BarChart3', 5, (SELECT id FROM menus WHERE code = 'MATERIAL_MGMT')),
('Issues & Consumption', 'MATERIAL_MGMT_ISSUES', '/material-management/issues', 'Target', 6, (SELECT id FROM menus WHERE code = 'MATERIAL_MGMT')),
('Vendor Management', 'MATERIAL_MGMT_VENDORS', '/material-management/vendors', 'Users', 7, (SELECT id FROM menus WHERE code = 'MATERIAL_MGMT')),
('Schemes & Discounts', 'MATERIAL_MGMT_SCHEMES', '/material-management/schemes', 'DollarSign', 8, (SELECT id FROM menus WHERE code = 'MATERIAL_MGMT')),
('AI Optimization', 'MATERIAL_MGMT_AI_INSIGHTS', '/material-management/ai-insights', 'Zap', 9, (SELECT id FROM menus WHERE code = 'MATERIAL_MGMT'))
ON CONFLICT (code) DO NOTHING;

-- Insert Patients submenus
INSERT INTO menus (title, code, href, icon, sort_order, parent_id) VALUES
('Patient List', 'PATIENTS_LIST', '/patients', 'Users', 1, (SELECT id FROM menus WHERE code = 'PATIENTS')),
('Register Patient', 'PATIENTS_REGISTER', '/patients/register', 'User', 2, (SELECT id FROM menus WHERE code = 'PATIENTS'))
ON CONFLICT (code) DO NOTHING;

-- Insert Telecaller/CRM submenus
INSERT INTO menus (title, code, href, icon, sort_order, parent_id) VALUES
('Dashboard', 'TELECALLER_DASHBOARD', '/telecaller', 'LayoutDashboard', 1, (SELECT id FROM menus WHERE code = 'TELECALLER')),
('All Appointments', 'TELECALLER_APPOINTMENTS', '/telecaller/appointments', 'Calendar', 2, (SELECT id FROM menus WHERE code = 'TELECALLER')),
('Book Appointment', 'TELECALLER_BOOK_APPOINTMENT', '/telecaller/book-appointment', 'Calendar', 3, (SELECT id FROM menus WHERE code = 'TELECALLER')),
('Patient Search', 'TELECALLER_PATIENT_SEARCH', '/telecaller/patient-search', 'Users', 4, (SELECT id FROM menus WHERE code = 'TELECALLER')),
('Follow-ups', 'TELECALLER_FOLLOW_UPS', '/telecaller/follow-ups', 'Clock', 5, (SELECT id FROM menus WHERE code = 'TELECALLER')),
('Compliance Tracking', 'TELECALLER_COMPLIANCE', '/telecaller/compliance', 'UserCheck', 6, (SELECT id FROM menus WHERE code = 'TELECALLER')),
('Campaigns', 'TELECALLER_CAMPAIGNS', '/telecaller/campaigns', 'Target', 7, (SELECT id FROM menus WHERE code = 'TELECALLER')),
('Call History', 'TELECALLER_CALL_HISTORY', '/telecaller/call-history', 'Phone', 8, (SELECT id FROM menus WHERE code = 'TELECALLER')),
('Reports', 'TELECALLER_REPORTS', '/telecaller/reports', 'BarChart3', 9, (SELECT id FROM menus WHERE code = 'TELECALLER'))
ON CONFLICT (code) DO NOTHING;

-- Insert Doctors Module submenus
INSERT INTO menus (title, code, href, icon, sort_order, parent_id) VALUES
('Dashboard', 'DOCTORS_DASHBOARD', '/doctors', 'LayoutDashboard', 1, (SELECT id FROM menus WHERE code = 'DOCTORS')),
('Patient Workspace', 'DOCTORS_PATIENT', '/doctors/patient', 'Users', 2, (SELECT id FROM menus WHERE code = 'DOCTORS')),
('Chat Console', 'DOCTORS_CHAT', '/doctors/chat', 'MessageSquare', 3, (SELECT id FROM menus WHERE code = 'DOCTORS')),
('Rounds & Discharge', 'DOCTORS_ROUNDS', '/doctors/rounds', 'Bed', 4, (SELECT id FROM menus WHERE code = 'DOCTORS')),
('Communications', 'DOCTORS_COMMUNICATIONS', '/doctors/communications', 'FileText', 5, (SELECT id FROM menus WHERE code = 'DOCTORS')),
('Reports', 'DOCTORS_REPORTS', '/doctors/reports', 'BarChart3', 6, (SELECT id FROM menus WHERE code = 'DOCTORS')),
('Templates', 'DOCTORS_TEMPLATES', '/doctors/templates', 'FileText', 7, (SELECT id FROM menus WHERE code = 'DOCTORS'))
ON CONFLICT (code) DO NOTHING;

-- Insert Vitals submenus
INSERT INTO menus (title, code, href, icon, sort_order, parent_id) VALUES
('Vitals Dashboard', 'VITALS_DASHBOARD', '/vitals', 'BarChart3', 1, (SELECT id FROM menus WHERE code = 'VITALS')),
('Outpatient Vitals', 'VITALS_OUTPATIENT', '/vitals/outpatient', 'Users', 2, (SELECT id FROM menus WHERE code = 'VITALS'))
ON CONFLICT (code) DO NOTHING;

-- Insert Prescriptions submenus
INSERT INTO menus (title, code, href, icon, sort_order, parent_id) VALUES
('E-Prescriptions', 'PRESCRIPTIONS_EPRESCRIPTIONS', '/prescriptions', 'FileText', 1, (SELECT id FROM menus WHERE code = 'PRESCRIPTIONS')),
('Create Prescription', 'PRESCRIPTIONS_CREATE', '/prescriptions/create', 'FileText', 2, (SELECT id FROM menus WHERE code = 'PRESCRIPTIONS')),
('Prescription History', 'PRESCRIPTIONS_HISTORY', '/prescriptions/history', 'FileText', 3, (SELECT id FROM menus WHERE code = 'PRESCRIPTIONS'))
ON CONFLICT (code) DO NOTHING;

-- Insert Pharmacy submenus
INSERT INTO menus (title, code, href, icon, sort_order, parent_id) VALUES
('Pharmacy Dashboard', 'PHARMACY_DASHBOARD', '/pharmacy', 'Pill', 1, (SELECT id FROM menus WHERE code = 'PHARMACY')),
('Dispensing', 'PHARMACY_DISPENSING', '/pharmacy/dispensing', 'Pill', 2, (SELECT id FROM menus WHERE code = 'PHARMACY')),
('Sales', 'PHARMACY_SALES', '/pharmacy/sales', 'CreditCard', 3, (SELECT id FROM menus WHERE code = 'PHARMACY')),
('Billing', 'PHARMACY_BILLING', '/pharmacy/billing', 'CreditCard', 4, (SELECT id FROM menus WHERE code = 'PHARMACY')),
('Reports', 'PHARMACY_REPORTS', '/pharmacy/reports', 'BarChart3', 5, (SELECT id FROM menus WHERE code = 'PHARMACY'))
ON CONFLICT (code) DO NOTHING;

-- Insert Central Pharmacy submenus
INSERT INTO menus (title, code, href, icon, sort_order, parent_id) VALUES
('Dashboard', 'CENTRAL_PHARMACY_DASHBOARD', '/central-pharmacy', 'Building', 1, (SELECT id FROM menus WHERE code = 'CENTRAL_PHARMACY')),
('Purchase Orders', 'CENTRAL_PHARMACY_PURCHASE_ORDERS', '/central-pharmacy/purchase-orders', 'FileText', 2, (SELECT id FROM menus WHERE code = 'CENTRAL_PHARMACY')),
('GRN', 'CENTRAL_PHARMACY_GRN', '/central-pharmacy/grn', 'FileText', 3, (SELECT id FROM menus WHERE code = 'CENTRAL_PHARMACY')),
('Stock Management', 'CENTRAL_PHARMACY_STOCK', '/central-pharmacy/stock', 'Pill', 4, (SELECT id FROM menus WHERE code = 'CENTRAL_PHARMACY')),
('Transfers', 'CENTRAL_PHARMACY_TRANSFERS', '/central-pharmacy/transfers', 'FileText', 5, (SELECT id FROM menus WHERE code = 'CENTRAL_PHARMACY')),
('Vendors', 'CENTRAL_PHARMACY_VENDORS', '/central-pharmacy/vendors', 'Users', 6, (SELECT id FROM menus WHERE code = 'CENTRAL_PHARMACY')),
('AI Insights', 'CENTRAL_PHARMACY_AI_INSIGHTS', '/central-pharmacy/ai-insights', 'BarChart3', 7, (SELECT id FROM menus WHERE code = 'CENTRAL_PHARMACY')),
('Reports', 'CENTRAL_PHARMACY_REPORTS', '/central-pharmacy/reports', 'BarChart3', 8, (SELECT id FROM menus WHERE code = 'CENTRAL_PHARMACY'))
ON CONFLICT (code) DO NOTHING;

-- Insert Laboratory submenus
INSERT INTO menus (title, code, href, icon, sort_order, parent_id) VALUES
('Lab Dashboard', 'LABORATORY_DASHBOARD', '/lab', 'TestTube', 1, (SELECT id FROM menus WHERE code = 'LABORATORY')),
('Orders', 'LABORATORY_ORDERS', '/lab/orders', 'FileText', 2, (SELECT id FROM menus WHERE code = 'LABORATORY')),
('Collection', 'LABORATORY_COLLECTION', '/lab/collection', 'TestTube', 3, (SELECT id FROM menus WHERE code = 'LABORATORY')),
('Tracking', 'LABORATORY_TRACKING', '/lab/tracking', 'BarChart3', 4, (SELECT id FROM menus WHERE code = 'LABORATORY')),
('Results', 'LABORATORY_RESULTS', '/lab/results', 'FileText', 5, (SELECT id FROM menus WHERE code = 'LABORATORY')),
('Test Master', 'LABORATORY_TEST_MASTER', '/lab/test-master', 'Settings', 6, (SELECT id FROM menus WHERE code = 'LABORATORY'))
ON CONFLICT (code) DO NOTHING;

-- Insert Inpatient submenus
INSERT INTO menus (title, code, href, icon, sort_order, parent_id) VALUES
('Inpatient Dashboard', 'INPATIENT_DASHBOARD', '/inpatient', 'Bed', 1, (SELECT id FROM menus WHERE code = 'INPATIENT')),
('Bed Management', 'INPATIENT_BEDS', '/inpatient/beds', 'Bed', 2, (SELECT id FROM menus WHERE code = 'INPATIENT')),
('Admissions', 'INPATIENT_ADMISSION', '/inpatient/admission', 'Users', 3, (SELECT id FROM menus WHERE code = 'INPATIENT')),
('Transfers', 'INPATIENT_TRANSFERS', '/inpatient/transfers', 'FileText', 4, (SELECT id FROM menus WHERE code = 'INPATIENT')),
('Ward Census', 'INPATIENT_CENSUS', '/inpatient/census', 'BarChart3', 5, (SELECT id FROM menus WHERE code = 'INPATIENT'))
ON CONFLICT (code) DO NOTHING;

-- Insert Insurance & TPA submenus
INSERT INTO menus (title, code, href, icon, sort_order, parent_id) VALUES
('Insurance Dashboard', 'INSURANCE_DASHBOARD', '/insurance', 'Shield', 1, (SELECT id FROM menus WHERE code = 'INSURANCE')),
('Pre-Authorization', 'INSURANCE_PRE_AUTH', '/insurance/pre-auth', 'FileText', 2, (SELECT id FROM menus WHERE code = 'INSURANCE')),
('Claims', 'INSURANCE_CLAIMS', '/insurance/claims', 'FileText', 3, (SELECT id FROM menus WHERE code = 'INSURANCE')),
('TPA Management', 'INSURANCE_TPA', '/insurance/tpa', 'Users', 4, (SELECT id FROM menus WHERE code = 'INSURANCE')),
('Rate Agreements', 'INSURANCE_RATES', '/insurance/rates', 'CreditCard', 5, (SELECT id FROM menus WHERE code = 'INSURANCE')),
('Reports', 'INSURANCE_REPORTS', '/insurance/reports', 'BarChart3', 6, (SELECT id FROM menus WHERE code = 'INSURANCE'))
ON CONFLICT (code) DO NOTHING;

-- Insert Billing submenus
INSERT INTO menus (title, code, href, icon, sort_order, parent_id) VALUES
('Billing Dashboard', 'BILLING_DASHBOARD', '/billing', 'CreditCard', 1, (SELECT id FROM menus WHERE code = 'BILLING')),
('Outpatient Billing', 'BILLING_OUTPATIENT', '/billing/outpatient', 'Users', 2, (SELECT id FROM menus WHERE code = 'BILLING')),
('Inpatient Billing', 'BILLING_INPATIENT', '/billing/inpatient', 'Bed', 3, (SELECT id FROM menus WHERE code = 'BILLING')),
('Insurance Billing', 'BILLING_INSURANCE', '/billing/insurance', 'Shield', 4, (SELECT id FROM menus WHERE code = 'BILLING')),
('Quick Billing', 'BILLING_QUICK', '/billing/quick', 'CreditCard', 5, (SELECT id FROM menus WHERE code = 'BILLING')),
('Cashier', 'BILLING_CASHIER', '/billing/cashier', 'CreditCard', 6, (SELECT id FROM menus WHERE code = 'BILLING')),
('Services', 'BILLING_SERVICES', '/billing/services', 'Settings', 7, (SELECT id FROM menus WHERE code = 'BILLING')),
('Price Lists', 'BILLING_PRICE_LISTS', '/billing/price-lists', 'FileText', 8, (SELECT id FROM menus WHERE code = 'BILLING')),
('Packages', 'BILLING_PACKAGES', '/billing/packages', 'FileText', 9, (SELECT id FROM menus WHERE code = 'BILLING')),
('Discounts', 'BILLING_DISCOUNTS', '/billing/discounts', 'FileText', 10, (SELECT id FROM menus WHERE code = 'BILLING')),
('Accounts', 'BILLING_ACCOUNTS', '/billing/accounts', 'BarChart3', 11, (SELECT id FROM menus WHERE code = 'BILLING')),
('Reports', 'BILLING_REPORTS', '/billing/reports', 'BarChart3', 12, (SELECT id FROM menus WHERE code = 'BILLING')),
('Settings', 'BILLING_SETTINGS', '/billing/settings', 'Settings', 13, (SELECT id FROM menus WHERE code = 'BILLING'))
ON CONFLICT (code) DO NOTHING;

-- Assign menus to roles
-- Super Admin gets all menus
INSERT INTO role_menus (role_id, menu_id)
SELECT r.id, m.id FROM roles r, menus m WHERE r.code = 'SUPER_ADMIN'
ON CONFLICT DO NOTHING;

-- Admin gets all menus
INSERT INTO role_menus (role_id, menu_id)
SELECT r.id, m.id FROM roles r, menus m WHERE r.code = 'ADMIN'
ON CONFLICT DO NOTHING;

-- Front Office gets only front office menus
INSERT INTO role_menus (role_id, menu_id)
SELECT r.id, m.id FROM roles r, menus m 
WHERE r.code = 'FRONT_OFFICE' AND (m.code LIKE 'FRONT_OFFICE%' OR m.code = 'DASHBOARD')
ON CONFLICT DO NOTHING;

-- Doctor gets relevant menus
INSERT INTO role_menus (role_id, menu_id)
SELECT r.id, m.id FROM roles r, menus m 
WHERE r.code = 'DOCTOR' AND m.code IN ('DASHBOARD', 'PATIENTS', 'DOCTORS', 'PRESCRIPTIONS', 'LABORATORY')
ON CONFLICT DO NOTHING;

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_menus_parent_id ON menus(parent_id);
CREATE INDEX IF NOT EXISTS idx_menus_sort_order ON menus(sort_order);
CREATE INDEX IF NOT EXISTS idx_role_menus_role_id ON role_menus(role_id);
CREATE INDEX IF NOT EXISTS idx_role_menus_menu_id ON role_menus(menu_id);