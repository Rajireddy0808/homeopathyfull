-- Role Permissions System Setup
-- Add new tables for role-based permissions

-- Create roles table
CREATE TABLE IF NOT EXISTS roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    code VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create permissions table
CREATE TABLE IF NOT EXISTS permissions (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    code VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    module VARCHAR(50) NOT NULL,
    action VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create role_permissions junction table
CREATE TABLE IF NOT EXISTS role_permissions (
    id SERIAL PRIMARY KEY,
    role_id INTEGER NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    permission_id INTEGER NOT NULL REFERENCES permissions(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(role_id, permission_id)
);

-- Add role_id column to users table
ALTER TABLE users ADD COLUMN IF NOT EXISTS role_id INTEGER REFERENCES roles(id);

-- Insert default roles
INSERT INTO roles (name, code, description) VALUES
('Super Admin', 'SUPER_ADMIN', 'Full system access'),
('Admin', 'ADMIN', 'Administrative access to all modules'),
('Doctor', 'DOCTOR', 'Medical staff with patient access'),
('Nurse', 'NURSE', 'Nursing staff with patient care access'),
('Pharmacist', 'PHARMACIST', 'Pharmacy operations access'),
('Lab Technician', 'LAB_TECH', 'Laboratory operations access'),
('Front Office', 'FRONT_OFFICE', 'Patient registration and appointments'),
('Billing', 'BILLING', 'Billing and financial operations'),
('Telecaller', 'TELECALLER', 'Patient communication and follow-ups'),
('Material Manager', 'MATERIAL_MGR', 'Inventory and material management')
ON CONFLICT (code) DO NOTHING;

-- Update existing users with role_id based on their current role enum
UPDATE users SET role_id = (
    SELECT r.id FROM roles r 
    WHERE r.code = CASE 
        WHEN users.role = 'SUPER_ADMIN' THEN 'SUPER_ADMIN'
        WHEN users.role = 'ADMIN' THEN 'ADMIN'
        WHEN users.role = 'DOCTOR' THEN 'DOCTOR'
        WHEN users.role = 'NURSE' THEN 'NURSE'
        WHEN users.role = 'PHARMACIST' THEN 'PHARMACIST'
        WHEN users.role = 'LAB_TECHNICIAN' THEN 'LAB_TECH'
        WHEN users.role = 'FRONT_OFFICE' THEN 'FRONT_OFFICE'
        WHEN users.role = 'BILLING' THEN 'BILLING'
        WHEN users.role = 'TELECALLER' THEN 'TELECALLER'
        WHEN users.role = 'MATERIAL_MANAGER' THEN 'MATERIAL_MGR'
        ELSE 'FRONT_OFFICE'
    END
) WHERE role_id IS NULL;

-- Insert default permissions
INSERT INTO permissions (name, code, description, module, action) VALUES
-- Patient Management
('View Patients', 'PATIENTS_READ', 'View patient information', 'patients', 'read'),
('Create Patients', 'PATIENTS_CREATE', 'Register new patients', 'patients', 'create'),
('Update Patients', 'PATIENTS_UPDATE', 'Update patient information', 'patients', 'update'),
('Delete Patients', 'PATIENTS_DELETE', 'Delete patient records', 'patients', 'delete'),

-- Appointments
('View Appointments', 'APPOINTMENTS_READ', 'View appointment schedules', 'appointments', 'read'),
('Create Appointments', 'APPOINTMENTS_CREATE', 'Schedule new appointments', 'appointments', 'create'),
('Update Appointments', 'APPOINTMENTS_UPDATE', 'Modify appointments', 'appointments', 'update'),
('Cancel Appointments', 'APPOINTMENTS_DELETE', 'Cancel appointments', 'appointments', 'delete'),

-- Prescriptions
('View Prescriptions', 'PRESCRIPTIONS_READ', 'View prescriptions', 'prescriptions', 'read'),
('Create Prescriptions', 'PRESCRIPTIONS_CREATE', 'Create new prescriptions', 'prescriptions', 'create'),
('Update Prescriptions', 'PRESCRIPTIONS_UPDATE', 'Modify prescriptions', 'prescriptions', 'update'),

-- Pharmacy
('View Pharmacy', 'PHARMACY_READ', 'View pharmacy operations', 'pharmacy', 'read'),
('Dispense Medicine', 'PHARMACY_DISPENSE', 'Dispense medications', 'pharmacy', 'dispense'),
('Manage Inventory', 'PHARMACY_INVENTORY', 'Manage pharmacy inventory', 'pharmacy', 'inventory'),

-- Laboratory
('View Lab Orders', 'LAB_READ', 'View laboratory orders', 'lab', 'read'),
('Create Lab Orders', 'LAB_CREATE', 'Create lab orders', 'lab', 'create'),
('Update Lab Results', 'LAB_UPDATE', 'Update lab results', 'lab', 'update'),

-- Billing
('View Bills', 'BILLING_READ', 'View billing information', 'billing', 'read'),
('Create Bills', 'BILLING_CREATE', 'Generate bills', 'billing', 'create'),
('Process Payments', 'BILLING_PAYMENT', 'Process payments', 'billing', 'payment'),
('Manage Discounts', 'BILLING_DISCOUNT', 'Apply discounts', 'billing', 'discount'),

-- Reports
('View Reports', 'REPORTS_READ', 'View system reports', 'reports', 'read'),
('Generate Reports', 'REPORTS_CREATE', 'Generate new reports', 'reports', 'create'),

-- System Administration
('User Management', 'USERS_MANAGE', 'Manage system users', 'admin', 'users'),
('System Settings', 'SYSTEM_SETTINGS', 'Manage system settings', 'admin', 'settings'),
('Role Management', 'ROLES_MANAGE', 'Manage roles and permissions', 'admin', 'roles')
ON CONFLICT (code) DO NOTHING;

-- Assign permissions to roles
-- Super Admin gets all permissions
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r, permissions p WHERE r.code = 'SUPER_ADMIN'
ON CONFLICT DO NOTHING;

-- Admin gets all permissions
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r, permissions p WHERE r.code = 'ADMIN'
ON CONFLICT DO NOTHING;

-- Doctor permissions
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r, permissions p 
WHERE r.code = 'DOCTOR' AND p.code IN (
    'PATIENTS_READ', 'PATIENTS_UPDATE', 'APPOINTMENTS_READ', 'APPOINTMENTS_UPDATE',
    'PRESCRIPTIONS_READ', 'PRESCRIPTIONS_CREATE', 'PRESCRIPTIONS_UPDATE',
    'LAB_READ', 'LAB_CREATE', 'REPORTS_READ'
)
ON CONFLICT DO NOTHING;

-- Nurse permissions
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r, permissions p 
WHERE r.code = 'NURSE' AND p.code IN (
    'PATIENTS_READ', 'PATIENTS_UPDATE', 'APPOINTMENTS_READ',
    'PRESCRIPTIONS_READ', 'LAB_READ'
)
ON CONFLICT DO NOTHING;

-- Pharmacist permissions
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r, permissions p 
WHERE r.code = 'PHARMACIST' AND p.code IN (
    'PATIENTS_READ', 'PRESCRIPTIONS_READ', 'PHARMACY_READ', 
    'PHARMACY_DISPENSE', 'PHARMACY_INVENTORY'
)
ON CONFLICT DO NOTHING;

-- Lab Technician permissions
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r, permissions p 
WHERE r.code = 'LAB_TECH' AND p.code IN (
    'PATIENTS_READ', 'LAB_READ', 'LAB_CREATE', 'LAB_UPDATE'
)
ON CONFLICT DO NOTHING;

-- Front Office permissions (only front office module)
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r, permissions p 
WHERE r.code = 'FRONT_OFFICE' AND p.module = 'patients'
ON CONFLICT DO NOTHING;

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r, permissions p 
WHERE r.code = 'FRONT_OFFICE' AND p.module = 'appointments'
ON CONFLICT DO NOTHING;

-- Billing permissions
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r, permissions p 
WHERE r.code = 'BILLING' AND p.code IN (
    'PATIENTS_READ', 'BILLING_READ', 'BILLING_CREATE', 
    'BILLING_PAYMENT', 'BILLING_DISCOUNT', 'REPORTS_READ'
)
ON CONFLICT DO NOTHING;

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_role_permissions_role_id ON role_permissions(role_id);
CREATE INDEX IF NOT EXISTS idx_role_permissions_permission_id ON role_permissions(permission_id);
CREATE INDEX IF NOT EXISTS idx_users_role_id ON users(role_id);