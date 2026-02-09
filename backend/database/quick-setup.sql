-- Quick setup for login functionality
-- Run this if the main database setup hasn't been executed

-- Create locations table if not exists
CREATE TABLE IF NOT EXISTS locations (
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

-- Create roles table if not exists
CREATE TABLE IF NOT EXISTS roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    code VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create users table if not exists
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('admin', 'doctor', 'nurse', 'pharmacist', 'lab_technician', 'front_office', 'telecaller', 'billing', 'material_manager')),
    location_id INTEGER NOT NULL REFERENCES locations(id),
    role_id INTEGER REFERENCES roles(id),
    is_active BOOLEAN DEFAULT true,
    phone VARCHAR(15),
    department VARCHAR(50),
    specialization VARCHAR(100),
    license_number VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create menus table if not exists
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

-- Create role_menus table if not exists
CREATE TABLE IF NOT EXISTS role_menus (
    id SERIAL PRIMARY KEY,
    role_id INTEGER NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    menu_id INTEGER NOT NULL REFERENCES menus(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(role_id, menu_id)
);

-- Insert sample location
INSERT INTO locations (location_code, name, address, phone, email) VALUES
('LOC001', 'Main Hospital', '123 Hospital Street, City Center, State 12345', '9876543200', 'main@hospital.com')
ON CONFLICT (location_code) DO NOTHING;

-- Insert default roles
INSERT INTO roles (name, code, description) VALUES
('Super Admin', 'SUPER_ADMIN', 'Full system access'),
('Admin', 'ADMIN', 'Administrative access to all modules')
ON CONFLICT (code) DO NOTHING;

-- Insert admin user
INSERT INTO users (username, email, password, first_name, last_name, role, location_id, role_id) VALUES
('admin', 'admin@hospital.com', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Admin', 'User', 'admin', 1, 1)
ON CONFLICT (username) DO UPDATE SET 
    password = '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
    role_id = 1;

-- Insert basic menus
INSERT INTO menus (title, code, href, icon, sort_order) VALUES
('Dashboard', 'DASHBOARD', '/dashboard', 'Home', 1),
('Patients', 'PATIENTS', '/patients', 'Users', 2),
('Appointments', 'APPOINTMENTS', '/appointments', 'Calendar', 3),
('Billing', 'BILLING', '/billing', 'CreditCard', 4),
('Settings', 'SETTINGS', '/settings', 'Settings', 5)
ON CONFLICT (code) DO NOTHING;

-- Assign all menus to admin role
INSERT INTO role_menus (role_id, menu_id)
SELECT r.id, m.id FROM roles r, menus m WHERE r.code = 'ADMIN'
ON CONFLICT DO NOTHING;