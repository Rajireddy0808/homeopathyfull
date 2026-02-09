-- Insert all sample data migration

-- Locations
INSERT INTO locations (location_code, name, address, phone, email) VALUES
('LOC001', 'Main Hospital', '123 Hospital Street, City Center', '9876543200', 'main@hospital.com'),
('LOC002', 'Branch Clinic', '456 North Avenue, North District', '9876543201', 'north@hospital.com');

-- Departments
INSERT INTO departments (department_code, name, description, location_id) VALUES
('CARD', 'Cardiology', 'Heart and cardiovascular diseases', 1),
('ORTH', 'Orthopedics', 'Bone and joint disorders', 1),
('PEDI', 'Pediatrics', 'Child healthcare', 1),
('GMED', 'General Medicine', 'General medical consultation', 1),
('PHARM', 'Pharmacy', 'Medicine dispensing', 1),
('LAB', 'Laboratory', 'Diagnostic testing', 1),
('FRONT', 'Front Office', 'Patient registration and billing', 1);

-- Roles
INSERT INTO roles (role_name, description) VALUES
('admin', 'System Administrator'),
('doctor', 'Medical Doctor'),
('nurse', 'Nursing Staff'),
('pharmacist', 'Pharmacy Staff'),
('lab_technician', 'Laboratory Technician'),
('front_office', 'Front Office Staff'),
('billing', 'Billing Staff'),
('telecaller', 'Telecaller Staff');

-- Modules
INSERT INTO modules (module_name, description, icon, route, sort_order) VALUES
('Dashboard', 'Main dashboard', 'dashboard', '/dashboard', 1),
('Patient Management', 'Patient registration and records', 'users', '/patients', 2),
('Appointments', 'Appointment scheduling', 'calendar', '/appointments', 3),
('Clinical', 'Clinical operations', 'stethoscope', '/clinical', 4),
('Pharmacy', 'Pharmacy management', 'pills', '/pharmacy', 5),
('Laboratory', 'Lab tests and reports', 'flask', '/laboratory', 6),
('Billing', 'Billing and payments', 'credit-card', '/billing', 7),
('Reports', 'Reports and analytics', 'chart-bar', '/reports', 8),
('Settings', 'System settings', 'cog', '/settings', 9);

-- Sub Modules
INSERT INTO sub_modules (module_id, sub_module_name, description, route, sort_order) VALUES
(2, 'Patient Registration', 'Register new patients', '/patients/register', 1),
(2, 'Patient List', 'View all patients', '/patients/list', 2),
(3, 'Book Appointment', 'Schedule new appointment', '/appointments/book', 1),
(3, 'Appointment List', 'View appointments', '/appointments/list', 2),
(4, 'Consultation', 'Patient consultation', '/clinical/consultation', 1),
(4, 'Prescriptions', 'Manage prescriptions', '/clinical/prescriptions', 2),
(5, 'Medicine Inventory', 'Manage medicines', '/pharmacy/inventory', 1),
(5, 'Dispense Medicine', 'Dispense prescriptions', '/pharmacy/dispense', 2),
(6, 'Lab Tests', 'Manage lab tests', '/laboratory/tests', 1),
(6, 'Test Results', 'Enter test results', '/laboratory/results', 2),
(7, 'Generate Bill', 'Create patient bills', '/billing/generate', 1),
(7, 'Payment Collection', 'Collect payments', '/billing/payment', 2),
(9, 'User Management', 'Manage system users', '/settings/users', 1),
(9, 'System Settings', 'Configure system', '/settings/system', 2);

-- Users
INSERT INTO users (username, email, password, first_name, last_name, phone, role_id, department_id, location_id) VALUES
('admin', 'admin@hospital.com', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', 'System', 'Admin', '9876543210', 1, 7, 1),
('dr.smith', 'dr.smith@hospital.com', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', 'John', 'Smith', '9876543211', 2, 1, 1),
('dr.johnson', 'dr.johnson@hospital.com', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', 'Sarah', 'Johnson', '9876543212', 2, 3, 1),
('nurse.mary', 'nurse.mary@hospital.com', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', 'Mary', 'Wilson', '9876543213', 3, 4, 1),
('pharm.bob', 'pharm.bob@hospital.com', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', 'Bob', 'Anderson', '9876543214', 4, 5, 1),
('lab.tech', 'lab.tech@hospital.com', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', 'Lisa', 'Brown', '9876543215', 5, 6, 1),
('front.desk', 'front.desk@hospital.com', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', 'Emma', 'Davis', '9876543216', 6, 7, 1);

-- Service Types
INSERT INTO service_type (type_name, description) VALUES
('Consultation', 'Medical consultation services'),
('Diagnostic', 'Diagnostic procedures'),
('Laboratory', 'Laboratory tests'),
('Radiology', 'Radiology services'),
('Pharmacy', 'Pharmacy services'),
('Surgery', 'Surgical procedures');

-- Doctor Consultation Fees
INSERT INTO doctor_consultation_fee (doctor_id, location_id, consultation_fee, follow_up_fee, emergency_fee, effective_from) VALUES
(2, 1, 800.00, 500.00, 1200.00, CURRENT_DATE),
(3, 1, 600.00, 400.00, 900.00, CURRENT_DATE);

-- Doctor Timeslots
INSERT INTO doctor_timeslots (doctor_id, location_id, day_of_week, start_time, end_time, slot_duration) VALUES
(2, 1, 1, '09:00:00', '17:00:00', 30),
(2, 1, 2, '09:00:00', '17:00:00', 30),
(3, 1, 1, '10:00:00', '18:00:00', 30),
(3, 1, 3, '10:00:00', '18:00:00', 30);

-- Hospital Settings
INSERT INTO hospital_settings (location_id, setting_key, setting_value, description, updated_by) VALUES
(1, 'appointment_duration', '30', 'Default appointment duration in minutes', 1),
(1, 'max_appointments_per_slot', '1', 'Maximum appointments per time slot', 1),
(1, 'enable_online_booking', 'true', 'Enable online appointment booking', 1);

-- User Status
INSERT INTO user_status (user_id, status) VALUES
(1, 'active'), (2, 'active'), (3, 'active'), (4, 'active'), (5, 'active'), (6, 'active'), (7, 'active');

-- User Location Permissions
INSERT INTO user_location_permissions (user_id, location_id, is_default) VALUES
(1, 1, true), (2, 1, true), (3, 1, true), (4, 1, true), (5, 1, true), (6, 1, true), (7, 1, true);

-- User Access (Admin full access)
INSERT INTO user_access (user_id, module_id, can_view, can_create, can_edit, can_delete) VALUES
(1, 1, true, true, true, true), (1, 2, true, true, true, true), (1, 3, true, true, true, true),
(1, 4, true, true, true, true), (1, 5, true, true, true, true), (1, 6, true, true, true, true),
(1, 7, true, true, true, true), (1, 8, true, true, true, true), (1, 9, true, true, true, true);