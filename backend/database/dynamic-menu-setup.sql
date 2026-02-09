-- Dynamic Menu System Setup
-- Create new tables for dynamic menu and submenus

-- Create roles table
CREATE TABLE public.roles (
    id bigint PRIMARY KEY,
    name character varying(250),
    location_id integer,
    Is_Active character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

-- Add role_id column to users table
ALTER TABLE users ADD COLUMN IF NOT EXISTS role_id INTEGER REFERENCES roles(id);

-- Create modules table
CREATE TABLE public.modules (
    id bigint PRIMARY KEY,
    path character varying(250),
    name character varying(250),
    icon character varying(1000),
    "order" bigint,
    status integer,
    created_at timestamp without time zone
);

-- Create sub_modules table
CREATE TABLE public.sub_modules (
    id bigint PRIMARY KEY,
    module_id bigint,
    subcat_name character varying(250),
    subcat_path character varying(250),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

-- Create user_access table
CREATE TABLE public.user_access (
    id bigint PRIMARY KEY,
    role_id bigint,
    module_id bigint,
    sub_module_id integer,
    add integer,
    edit integer,
    delete integer,
    view integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

-- Insert modules data
INSERT INTO modules (id, path, name, icon, "order", status, created_at) VALUES
(1, 'dashboard', 'Dashboard', 'home', 1, 1, NOW()),
(2, 'front-office', 'Front Office', 'users', 2, 1, NOW()),
(3, 'patient-portal', 'Patient Portal', 'user', 3, 1, NOW()),
(4, 'material-management', 'Material Management', 'package', 4, 1, NOW()),
(5, 'patients', 'Patients', 'users', 5, 1, NOW()),
(6, 'telecaller', 'Telecaller/CRM', 'phone', 6, 1, NOW()),
(7, 'doctors', 'Doctors Module', 'stethoscope', 7, 1, NOW()),
(8, 'queue', 'Queue Management', 'calendar', 8, 1, NOW()),
(9, 'vitals', 'Vitals', 'bar-chart-3', 9, 1, NOW()),
(10, 'prescriptions', 'Prescriptions', 'file-text', 10, 1, NOW()),
(11, 'pharmacy', 'Pharmacy', 'pill', 11, 1, NOW()),
(12, 'central-pharmacy', 'Central Pharmacy', 'building', 12, 1, NOW()),
(13, 'laboratory', 'Laboratory', 'test-tube', 13, 1, NOW()),
(14, 'inpatient', 'Inpatient', 'bed', 14, 1, NOW()),
(15, 'insurance', 'Insurance & TPA', 'shield', 15, 1, NOW()),
(16, 'billing', 'Billing', 'credit-card', 16, 1, NOW()),
(17, 'settings', 'Settings', 'user-cog', 17, 1, NOW());

-- Insert sub_modules data
-- Front Office submodules
INSERT INTO sub_modules (id, module_id, subcat_name, subcat_path, created_at, updated_at) VALUES
(1, 2, 'Dashboard', 'front-office', NOW(), NOW()),
(2, 2, 'Patient Registration', 'front-office/registration', NOW(), NOW()),
(3, 2, 'Appointments', 'front-office/appointments', NOW(), NOW()),
(4, 2, 'OP Billing', 'front-office/billing', NOW(), NOW()),
(5, 2, 'Adjustments & Credits', 'front-office/adjustments', NOW(), NOW()),
(6, 2, 'Estimates & Deposits', 'front-office/estimates', NOW(), NOW()),
(7, 2, 'Investigations', 'front-office/investigations', NOW(), NOW()),
(8, 2, 'Payments & Receipts', 'front-office/payments', NOW(), NOW()),
(9, 2, 'Due Bills', 'front-office/due-bills', NOW(), NOW()),
(10, 2, 'Customer Service', 'front-office/customer-service', NOW(), NOW()),
(11, 2, 'Insurance Desk', 'front-office/insurance', NOW(), NOW()),
(12, 2, 'Shift Management', 'front-office/shifts', NOW(), NOW()),
(13, 2, 'Reports', 'front-office/reports', NOW(), NOW()),

-- Patient Portal submodules
(14, 3, 'Portal Dashboard', 'patient-portal', NOW(), NOW()),
(15, 3, 'My Appointments', 'patient-portal/appointments', NOW(), NOW()),
(16, 3, 'Book Appointment', 'patient-portal/appointments/book', NOW(), NOW()),
(17, 3, 'Prescriptions', 'patient-portal/prescriptions', NOW(), NOW()),
(18, 3, 'Lab Reports', 'patient-portal/lab-reports', NOW(), NOW()),
(19, 3, 'Bills & Payments', 'patient-portal/bills', NOW(), NOW()),
(20, 3, 'Health History', 'patient-portal/health-history', NOW(), NOW()),
(21, 3, 'Support', 'patient-portal/support', NOW(), NOW()),

-- Material Management submodules
(22, 4, 'Dashboard', 'material-management', NOW(), NOW()),
(23, 4, 'Masters & Catalogs', 'material-management/masters', NOW(), NOW()),
(24, 4, 'Procurement', 'material-management/procurement', NOW(), NOW()),
(25, 4, 'Inbound Operations', 'material-management/inbound', NOW(), NOW()),
(26, 4, 'Inventory Management', 'material-management/inventory', NOW(), NOW()),
(27, 4, 'Issues & Consumption', 'material-management/issues', NOW(), NOW()),
(28, 4, 'Vendor Management', 'material-management/vendors', NOW(), NOW()),
(29, 4, 'Schemes & Discounts', 'material-management/schemes', NOW(), NOW()),
(30, 4, 'AI Optimization', 'material-management/ai-insights', NOW(), NOW()),

-- Patients submodules
(31, 5, 'Patient List', 'patients', NOW(), NOW()),
(32, 5, 'Register Patient', 'patients/register', NOW(), NOW()),

-- Telecaller/CRM submodules
(33, 6, 'Dashboard', 'telecaller', NOW(), NOW()),
(34, 6, 'All Appointments', 'telecaller/appointments', NOW(), NOW()),
(35, 6, 'Book Appointment', 'telecaller/book-appointment', NOW(), NOW()),
(36, 6, 'Patient Search', 'telecaller/patient-search', NOW(), NOW()),
(37, 6, 'Follow-ups', 'telecaller/follow-ups', NOW(), NOW()),
(38, 6, 'Compliance Tracking', 'telecaller/compliance', NOW(), NOW()),
(39, 6, 'Campaigns', 'telecaller/campaigns', NOW(), NOW()),
(40, 6, 'Call History', 'telecaller/call-history', NOW(), NOW()),
(41, 6, 'Reports', 'telecaller/reports', NOW(), NOW()),

-- Doctors Module submodules
(42, 7, 'Dashboard', 'doctors', NOW(), NOW()),
(43, 7, 'Patient Workspace', 'doctors/patient', NOW(), NOW()),
(44, 7, 'Chat Console', 'doctors/chat', NOW(), NOW()),
(45, 7, 'Rounds & Discharge', 'doctors/rounds', NOW(), NOW()),
(46, 7, 'Communications', 'doctors/communications', NOW(), NOW()),
(47, 7, 'Reports', 'doctors/reports', NOW(), NOW()),
(48, 7, 'Templates', 'doctors/templates', NOW(), NOW()),

-- Vitals submodules
(49, 9, 'Vitals Dashboard', 'vitals', NOW(), NOW()),
(50, 9, 'Outpatient Vitals', 'vitals/outpatient', NOW(), NOW()),

-- Prescriptions submodules
(51, 10, 'E-Prescriptions', 'prescriptions', NOW(), NOW()),
(52, 10, 'Create Prescription', 'prescriptions/create', NOW(), NOW()),
(53, 10, 'Prescription History', 'prescriptions/history', NOW(), NOW()),

-- Pharmacy submodules
(54, 11, 'Pharmacy Dashboard', 'pharmacy', NOW(), NOW()),
(55, 11, 'Dispensing', 'pharmacy/dispensing', NOW(), NOW()),
(56, 11, 'Sales', 'pharmacy/sales', NOW(), NOW()),
(57, 11, 'Billing', 'pharmacy/billing', NOW(), NOW()),
(58, 11, 'Reports', 'pharmacy/reports', NOW(), NOW()),

-- Central Pharmacy submodules
(59, 12, 'Dashboard', 'central-pharmacy', NOW(), NOW()),
(60, 12, 'Purchase Orders', 'central-pharmacy/purchase-orders', NOW(), NOW()),
(61, 12, 'GRN', 'central-pharmacy/grn', NOW(), NOW()),
(62, 12, 'Stock Management', 'central-pharmacy/stock', NOW(), NOW()),
(63, 12, 'Transfers', 'central-pharmacy/transfers', NOW(), NOW()),
(64, 12, 'Vendors', 'central-pharmacy/vendors', NOW(), NOW()),
(65, 12, 'AI Insights', 'central-pharmacy/ai-insights', NOW(), NOW()),
(66, 12, 'Reports', 'central-pharmacy/reports', NOW(), NOW()),

-- Laboratory submodules
(67, 13, 'Lab Dashboard', 'lab', NOW(), NOW()),
(68, 13, 'Orders', 'lab/orders', NOW(), NOW()),
(69, 13, 'Collection', 'lab/collection', NOW(), NOW()),
(70, 13, 'Tracking', 'lab/tracking', NOW(), NOW()),
(71, 13, 'Results', 'lab/results', NOW(), NOW()),
(72, 13, 'Test Master', 'lab/test-master', NOW(), NOW()),

-- Inpatient submodules
(73, 14, 'Inpatient Dashboard', 'inpatient', NOW(), NOW()),
(74, 14, 'Bed Management', 'inpatient/beds', NOW(), NOW()),
(75, 14, 'Admissions', 'inpatient/admission', NOW(), NOW()),
(76, 14, 'Transfers', 'inpatient/transfers', NOW(), NOW()),
(77, 14, 'Ward Census', 'inpatient/census', NOW(), NOW()),

-- Insurance & TPA submodules
(78, 15, 'Insurance Dashboard', 'insurance', NOW(), NOW()),
(79, 15, 'Pre-Authorization', 'insurance/pre-auth', NOW(), NOW()),
(80, 15, 'Claims', 'insurance/claims', NOW(), NOW()),
(81, 15, 'TPA Management', 'insurance/tpa', NOW(), NOW()),
(82, 15, 'Rate Agreements', 'insurance/rates', NOW(), NOW()),
(83, 15, 'Reports', 'insurance/reports', NOW(), NOW()),

-- Billing submodules
(84, 16, 'Billing Dashboard', 'billing', NOW(), NOW()),
(85, 16, 'Outpatient Billing', 'billing/outpatient', NOW(), NOW()),
(86, 16, 'Inpatient Billing', 'billing/inpatient', NOW(), NOW()),
(87, 16, 'Insurance Billing', 'billing/insurance', NOW(), NOW()),
(88, 16, 'Quick Billing', 'billing/quick', NOW(), NOW()),
(89, 16, 'Cashier', 'billing/cashier', NOW(), NOW()),
(90, 16, 'Services', 'billing/services', NOW(), NOW()),
(91, 16, 'Price Lists', 'billing/price-lists', NOW(), NOW()),
(92, 16, 'Packages', 'billing/packages', NOW(), NOW()),
(93, 16, 'Discounts', 'billing/discounts', NOW(), NOW()),
(94, 16, 'Accounts', 'billing/accounts', NOW(), NOW()),
(95, 16, 'Reports', 'billing/reports', NOW(), NOW()),
(96, 16, 'Settings', 'billing/settings', NOW(), NOW());

-- Insert roles data
INSERT INTO roles (id, name, location_id, Is_Active, created_at, updated_at) VALUES
(1, 'Super Admin', 1, 'Active', NOW(), NOW()),
(2, 'Admin', 1, 'Active', NOW(), NOW()),
(3, 'Doctor', 1, 'Active', NOW(), NOW()),
(4, 'Nurse', 1, 'Active', NOW(), NOW()),
(5, 'Pharmacist', 1, 'Active', NOW(), NOW()),
(6, 'Lab Technician', 1, 'Active', NOW(), NOW()),
(7, 'Front Office', 1, 'Active', NOW(), NOW()),
(8, 'Billing', 1, 'Active', NOW(), NOW()),
(9, 'Telecaller', 1, 'Active', NOW(), NOW()),
(10, 'Material Manager', 1, 'Active', NOW(), NOW());

-- Update users table with role_id
UPDATE users SET role_id = CASE 
    WHEN role = 'admin' THEN 2
    WHEN role = 'doctor' THEN 3
    WHEN role = 'nurse' THEN 4
    WHEN role = 'pharmacist' THEN 5
    WHEN role = 'lab_technician' THEN 6
    WHEN role = 'front_office' THEN 7
    WHEN role = 'billing' THEN 8
    WHEN role = 'telecaller' THEN 9
    WHEN role = 'material_manager' THEN 10
    ELSE 2
END
WHERE role_id IS NULL;

-- Admin permissions (role_id = 2) - Full access to all modules
INSERT INTO user_access (id, role_id, module_id, sub_module_id, add, edit, delete, view, created_at, updated_at) VALUES
(1, 2, 1, NULL, 0, 0, 0, 1, NOW(), NOW()),
(2, 2, 2, NULL, 1, 1, 1, 1, NOW(), NOW()),
(3, 2, 3, NULL, 1, 1, 1, 1, NOW(), NOW()),
(4, 2, 4, NULL, 1, 1, 1, 1, NOW(), NOW()),
(5, 2, 5, NULL, 1, 1, 1, 1, NOW(), NOW()),
(6, 2, 6, NULL, 1, 1, 1, 1, NOW(), NOW()),
(7, 2, 7, NULL, 1, 1, 1, 1, NOW(), NOW()),
(8, 2, 8, NULL, 1, 1, 1, 1, NOW(), NOW()),
(9, 2, 9, NULL, 1, 1, 1, 1, NOW(), NOW()),
(10, 2, 10, NULL, 1, 1, 1, 1, NOW(), NOW()),
(11, 2, 11, NULL, 1, 1, 1, 1, NOW(), NOW()),
(12, 2, 12, NULL, 1, 1, 1, 1, NOW(), NOW()),
(13, 2, 13, NULL, 1, 1, 1, 1, NOW(), NOW()),
(14, 2, 14, NULL, 1, 1, 1, 1, NOW(), NOW()),
(15, 2, 15, NULL, 1, 1, 1, 1, NOW(), NOW()),
(16, 2, 16, NULL, 1, 1, 1, 1, NOW(), NOW()),
(17, 2, 17, NULL, 1, 1, 1, 1, NOW(), NOW()),
-- All submodule permissions for Admin (role_id = 2)
-- Front Office submodules (1-13)
(101, 2, 2, 1, 0, 0, 0, 1, NOW(), NOW()),
(102, 2, 2, 2, 1, 1, 1, 1, NOW(), NOW()),
(103, 2, 2, 3, 1, 1, 1, 1, NOW(), NOW()),
(104, 2, 2, 4, 1, 1, 1, 1, NOW(), NOW()),
(105, 2, 2, 5, 1, 1, 1, 1, NOW(), NOW()),
(106, 2, 2, 6, 1, 1, 1, 1, NOW(), NOW()),
(107, 2, 2, 7, 1, 1, 1, 1, NOW(), NOW()),
(108, 2, 2, 8, 1, 1, 1, 1, NOW(), NOW()),
(109, 2, 2, 9, 1, 1, 1, 1, NOW(), NOW()),
(110, 2, 2, 10, 1, 1, 1, 1, NOW(), NOW()),
(111, 2, 2, 11, 1, 1, 1, 1, NOW(), NOW()),
(112, 2, 2, 12, 1, 1, 1, 1, NOW(), NOW()),
(113, 2, 2, 13, 1, 1, 1, 1, NOW(), NOW()),
-- Patient Portal submodules (14-21)
(114, 2, 3, 14, 1, 1, 1, 1, NOW(), NOW()),
(115, 2, 3, 15, 1, 1, 1, 1, NOW(), NOW()),
(116, 2, 3, 16, 1, 1, 1, 1, NOW(), NOW()),
(117, 2, 3, 17, 1, 1, 1, 1, NOW(), NOW()),
(118, 2, 3, 18, 1, 1, 1, 1, NOW(), NOW()),
(119, 2, 3, 19, 1, 1, 1, 1, NOW(), NOW()),
(120, 2, 3, 20, 1, 1, 1, 1, NOW(), NOW()),
(121, 2, 3, 21, 1, 1, 1, 1, NOW(), NOW()),
-- Material Management submodules (22-30)
(122, 2, 4, 22, 1, 1, 1, 1, NOW(), NOW()),
(123, 2, 4, 23, 1, 1, 1, 1, NOW(), NOW()),
(124, 2, 4, 24, 1, 1, 1, 1, NOW(), NOW()),
(125, 2, 4, 25, 1, 1, 1, 1, NOW(), NOW()),
(126, 2, 4, 26, 1, 1, 1, 1, NOW(), NOW()),
(127, 2, 4, 27, 1, 1, 1, 1, NOW(), NOW()),
(128, 2, 4, 28, 1, 1, 1, 1, NOW(), NOW()),
(129, 2, 4, 29, 1, 1, 1, 1, NOW(), NOW()),
(130, 2, 4, 30, 1, 1, 1, 1, NOW(), NOW()),
-- Patients submodules (31-32)
(131, 2, 5, 31, 1, 1, 1, 1, NOW(), NOW()),
(132, 2, 5, 32, 1, 1, 1, 1, NOW(), NOW()),
-- Telecaller submodules (33-41)
(133, 2, 6, 33, 1, 1, 1, 1, NOW(), NOW()),
(134, 2, 6, 34, 1, 1, 1, 1, NOW(), NOW()),
(135, 2, 6, 35, 1, 1, 1, 1, NOW(), NOW()),
(136, 2, 6, 36, 1, 1, 1, 1, NOW(), NOW()),
(137, 2, 6, 37, 1, 1, 1, 1, NOW(), NOW()),
(138, 2, 6, 38, 1, 1, 1, 1, NOW(), NOW()),
(139, 2, 6, 39, 1, 1, 1, 1, NOW(), NOW()),
(140, 2, 6, 40, 1, 1, 1, 1, NOW(), NOW()),
(141, 2, 6, 41, 1, 1, 1, 1, NOW(), NOW()),
-- Doctors submodules (42-48)
(142, 2, 7, 42, 1, 1, 1, 1, NOW(), NOW()),
(143, 2, 7, 43, 1, 1, 1, 1, NOW(), NOW()),
(144, 2, 7, 44, 1, 1, 1, 1, NOW(), NOW()),
(145, 2, 7, 45, 1, 1, 1, 1, NOW(), NOW()),
(146, 2, 7, 46, 1, 1, 1, 1, NOW(), NOW()),
(147, 2, 7, 47, 1, 1, 1, 1, NOW(), NOW()),
(148, 2, 7, 48, 1, 1, 1, 1, NOW(), NOW()),
-- Vitals submodules (49-50)
(149, 2, 9, 49, 1, 1, 1, 1, NOW(), NOW()),
(150, 2, 9, 50, 1, 1, 1, 1, NOW(), NOW()),
-- Prescriptions submodules (51-53)
(151, 2, 10, 51, 1, 1, 1, 1, NOW(), NOW()),
(152, 2, 10, 52, 1, 1, 1, 1, NOW(), NOW()),
(153, 2, 10, 53, 1, 1, 1, 1, NOW(), NOW()),
-- Pharmacy submodules (54-58)
(154, 2, 11, 54, 1, 1, 1, 1, NOW(), NOW()),
(155, 2, 11, 55, 1, 1, 1, 1, NOW(), NOW()),
(156, 2, 11, 56, 1, 1, 1, 1, NOW(), NOW()),
(157, 2, 11, 57, 1, 1, 1, 1, NOW(), NOW()),
(158, 2, 11, 58, 1, 1, 1, 1, NOW(), NOW()),
-- Central Pharmacy submodules (59-66)
(159, 2, 12, 59, 1, 1, 1, 1, NOW(), NOW()),
(160, 2, 12, 60, 1, 1, 1, 1, NOW(), NOW()),
(161, 2, 12, 61, 1, 1, 1, 1, NOW(), NOW()),
(162, 2, 12, 62, 1, 1, 1, 1, NOW(), NOW()),
(163, 2, 12, 63, 1, 1, 1, 1, NOW(), NOW()),
(164, 2, 12, 64, 1, 1, 1, 1, NOW(), NOW()),
(165, 2, 12, 65, 1, 1, 1, 1, NOW(), NOW()),
(166, 2, 12, 66, 1, 1, 1, 1, NOW(), NOW()),
-- Laboratory submodules (67-72)
(167, 2, 13, 67, 1, 1, 1, 1, NOW(), NOW()),
(168, 2, 13, 68, 1, 1, 1, 1, NOW(), NOW()),
(169, 2, 13, 69, 1, 1, 1, 1, NOW(), NOW()),
(170, 2, 13, 70, 1, 1, 1, 1, NOW(), NOW()),
(171, 2, 13, 71, 1, 1, 1, 1, NOW(), NOW()),
(172, 2, 13, 72, 1, 1, 1, 1, NOW(), NOW()),
-- Inpatient submodules (73-77)
(173, 2, 14, 73, 1, 1, 1, 1, NOW(), NOW()),
(174, 2, 14, 74, 1, 1, 1, 1, NOW(), NOW()),
(175, 2, 14, 75, 1, 1, 1, 1, NOW(), NOW()),
(176, 2, 14, 76, 1, 1, 1, 1, NOW(), NOW()),
(177, 2, 14, 77, 1, 1, 1, 1, NOW(), NOW()),
-- Insurance submodules (78-83)
(178, 2, 15, 78, 1, 1, 1, 1, NOW(), NOW()),
(179, 2, 15, 79, 1, 1, 1, 1, NOW(), NOW()),
(180, 2, 15, 80, 1, 1, 1, 1, NOW(), NOW()),
(181, 2, 15, 81, 1, 1, 1, 1, NOW(), NOW()),
(182, 2, 15, 82, 1, 1, 1, 1, NOW(), NOW()),
(183, 2, 15, 83, 1, 1, 1, 1, NOW(), NOW()),
-- Billing submodules (84-96)
(184, 2, 16, 84, 1, 1, 1, 1, NOW(), NOW()),
(185, 2, 16, 85, 1, 1, 1, 1, NOW(), NOW()),
(186, 2, 16, 86, 1, 1, 1, 1, NOW(), NOW()),
(187, 2, 16, 87, 1, 1, 1, 1, NOW(), NOW()),
(188, 2, 16, 88, 1, 1, 1, 1, NOW(), NOW()),
(189, 2, 16, 89, 1, 1, 1, 1, NOW(), NOW()),
(190, 2, 16, 90, 1, 1, 1, 1, NOW(), NOW()),
(191, 2, 16, 91, 1, 1, 1, 1, NOW(), NOW()),
(192, 2, 16, 92, 1, 1, 1, 1, NOW(), NOW()),
(193, 2, 16, 93, 1, 1, 1, 1, NOW(), NOW()),
(194, 2, 16, 94, 1, 1, 1, 1, NOW(), NOW()),
(195, 2, 16, 95, 1, 1, 1, 1, NOW(), NOW()),
(196, 2, 16, 96, 1, 1, 1, 1, NOW(), NOW()),
-- Front Office role (role_id = 7) - Limited access
(201, 7, 2, NULL, 1, 1, 0, 1, NOW(), NOW()),
(202, 7, 5, NULL, 1, 1, 0, 1, NOW(), NOW()),
(203, 7, 2, 2, 1, 1, 0, 1, NOW(), NOW()),
(204, 7, 2, 3, 1, 1, 0, 1, NOW(), NOW());', NOW(), NOW());

-- Insert roles data
INSERT INTO roles (id, name, location_id, Is_Active, created_at, updated_at) VALUES
(1, 'Super Admin', 1, 'Active', NOW(), NOW()),
(2, 'Admin', 1, 'Active', NOW(), NOW()),
(3, 'Doctor', 1, 'Active', NOW(), NOW()),
(4, 'Nurse', 1, 'Active', NOW(), NOW()),
(5, 'Pharmacist', 1, 'Active', NOW(), NOW()),
(6, 'Lab Technician', 1, 'Active', NOW(), NOW()),
(7, 'Front Office', 1, 'Active', NOW(), NOW()),
(8, 'Billing', 1, 'Active', NOW(), NOW()),
(9, 'Telecaller', 1, 'Active', NOW(), NOW()),
(10, 'Material Manager', 1, 'Active', NOW(), NOW());

-- Update users table with role_id based on existing role enum
UPDATE users SET role_id = CASE 
    WHEN role = 'admin' THEN 2
    WHEN role = 'doctor' THEN 3
    WHEN role = 'nurse' THEN 4
    WHEN role = 'pharmacist' THEN 5
    WHEN role = 'lab_technician' THEN 6
    WHEN role = 'front_office' THEN 7
    WHEN role = 'billing' THEN 8
    WHEN role = 'telecaller' THEN 9
    WHEN role = 'material_manager' THEN 10
    ELSE 2 -- Default to Admin
END
WHERE role_id IS NULL;