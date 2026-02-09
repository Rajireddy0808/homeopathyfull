-- Add icon field to sub_modules table
ALTER TABLE sub_modules ADD COLUMN IF NOT EXISTS icon character varying(1000);

-- Update sub_modules with appropriate icons
-- Front Office submodules
UPDATE sub_modules SET icon = 'layout-dashboard' WHERE id = 1; -- Dashboard
UPDATE sub_modules SET icon = 'user-plus' WHERE id = 2; -- Patient Registration
UPDATE sub_modules SET icon = 'calendar' WHERE id = 3; -- Appointments
UPDATE sub_modules SET icon = 'credit-card' WHERE id = 4; -- OP Billing
UPDATE sub_modules SET icon = 'dollar-sign' WHERE id = 5; -- Adjustments & Credits
UPDATE sub_modules SET icon = 'receipt' WHERE id = 6; -- Estimates & Deposits
UPDATE sub_modules SET icon = 'test-tube' WHERE id = 7; -- Investigations
UPDATE sub_modules SET icon = 'indian-rupee' WHERE id = 8; -- Payments & Receipts
UPDATE sub_modules SET icon = 'alert-triangle' WHERE id = 9; -- Due Bills
UPDATE sub_modules SET icon = 'phone' WHERE id = 10; -- Customer Service
UPDATE sub_modules SET icon = 'shield' WHERE id = 11; -- Insurance Desk
UPDATE sub_modules SET icon = 'clock' WHERE id = 12; -- Shift Management
UPDATE sub_modules SET icon = 'bar-chart-3' WHERE id = 13; -- Reports

-- Patient Portal submodules
UPDATE sub_modules SET icon = 'layout-dashboard' WHERE id = 14; -- Portal Dashboard
UPDATE sub_modules SET icon = 'calendar' WHERE id = 15; -- My Appointments
UPDATE sub_modules SET icon = 'user-plus' WHERE id = 16; -- Book Appointment
UPDATE sub_modules SET icon = 'file-text' WHERE id = 17; -- Prescriptions
UPDATE sub_modules SET icon = 'test-tube' WHERE id = 18; -- Lab Reports
UPDATE sub_modules SET icon = 'credit-card' WHERE id = 19; -- Bills & Payments
UPDATE sub_modules SET icon = 'user-check' WHERE id = 20; -- Health History
UPDATE sub_modules SET icon = 'message-square' WHERE id = 21; -- Support

-- Material Management submodules
UPDATE sub_modules SET icon = 'layout-dashboard' WHERE id = 22; -- Dashboard
UPDATE sub_modules SET icon = 'package' WHERE id = 23; -- Masters & Catalogs
UPDATE sub_modules SET icon = 'shopping-cart' WHERE id = 24; -- Procurement
UPDATE sub_modules SET icon = 'truck' WHERE id = 25; -- Inbound Operations
UPDATE sub_modules SET icon = 'package' WHERE id = 26; -- Inventory Management
UPDATE sub_modules SET icon = 'zap' WHERE id = 27; -- Issues & Consumption
UPDATE sub_modules SET icon = 'building' WHERE id = 28; -- Vendor Management
UPDATE sub_modules SET icon = 'target' WHERE id = 29; -- Schemes & Discounts
UPDATE sub_modules SET icon = 'bar-chart-3' WHERE id = 30; -- AI Optimization

-- Patients submodules
UPDATE sub_modules SET icon = 'users' WHERE id = 31; -- Patient List
UPDATE sub_modules SET icon = 'user-plus' WHERE id = 32; -- Register Patient

-- Telecaller/CRM submodules
UPDATE sub_modules SET icon = 'layout-dashboard' WHERE id = 33; -- Dashboard
UPDATE sub_modules SET icon = 'calendar' WHERE id = 34; -- All Appointments
UPDATE sub_modules SET icon = 'user-plus' WHERE id = 35; -- Book Appointment
UPDATE sub_modules SET icon = 'users' WHERE id = 36; -- Patient Search
UPDATE sub_modules SET icon = 'phone' WHERE id = 37; -- Follow-ups
UPDATE sub_modules SET icon = 'user-check' WHERE id = 38; -- Compliance Tracking
UPDATE sub_modules SET icon = 'target' WHERE id = 39; -- Campaigns
UPDATE sub_modules SET icon = 'phone' WHERE id = 40; -- Call History
UPDATE sub_modules SET icon = 'bar-chart-3' WHERE id = 41; -- Reports

-- Doctors Module submodules
UPDATE sub_modules SET icon = 'layout-dashboard' WHERE id = 42; -- Dashboard
UPDATE sub_modules SET icon = 'user' WHERE id = 43; -- Patient Workspace
UPDATE sub_modules SET icon = 'message-square' WHERE id = 44; -- Chat Console
UPDATE sub_modules SET icon = 'bed' WHERE id = 45; -- Rounds & Discharge
UPDATE sub_modules SET icon = 'phone' WHERE id = 46; -- Communications
UPDATE sub_modules SET icon = 'bar-chart-3' WHERE id = 47; -- Reports
UPDATE sub_modules SET icon = 'file-text' WHERE id = 48; -- Templates

-- Vitals submodules
UPDATE sub_modules SET icon = 'layout-dashboard' WHERE id = 49; -- Vitals Dashboard
UPDATE sub_modules SET icon = 'bar-chart-3' WHERE id = 50; -- Outpatient Vitals

-- Prescriptions submodules
UPDATE sub_modules SET icon = 'file-text' WHERE id = 51; -- E-Prescriptions
UPDATE sub_modules SET icon = 'user-plus' WHERE id = 52; -- Create Prescription
UPDATE sub_modules SET icon = 'clock' WHERE id = 53; -- Prescription History

-- Pharmacy submodules
UPDATE sub_modules SET icon = 'layout-dashboard' WHERE id = 54; -- Pharmacy Dashboard
UPDATE sub_modules SET icon = 'pill' WHERE id = 55; -- Dispensing
UPDATE sub_modules SET icon = 'shopping-cart' WHERE id = 56; -- Sales
UPDATE sub_modules SET icon = 'credit-card' WHERE id = 57; -- Billing
UPDATE sub_modules SET icon = 'bar-chart-3' WHERE id = 58; -- Reports

-- Central Pharmacy submodules
UPDATE sub_modules SET icon = 'layout-dashboard' WHERE id = 59; -- Dashboard
UPDATE sub_modules SET icon = 'shopping-cart' WHERE id = 60; -- Purchase Orders
UPDATE sub_modules SET icon = 'truck' WHERE id = 61; -- GRN
UPDATE sub_modules SET icon = 'package' WHERE id = 62; -- Stock Management
UPDATE sub_modules SET icon = 'zap' WHERE id = 63; -- Transfers
UPDATE sub_modules SET icon = 'building' WHERE id = 64; -- Vendors
UPDATE sub_modules SET icon = 'bar-chart-3' WHERE id = 65; -- AI Insights
UPDATE sub_modules SET icon = 'bar-chart-3' WHERE id = 66; -- Reports

-- Laboratory submodules
UPDATE sub_modules SET icon = 'layout-dashboard' WHERE id = 67; -- Lab Dashboard
UPDATE sub_modules SET icon = 'file-text' WHERE id = 68; -- Orders
UPDATE sub_modules SET icon = 'test-tube' WHERE id = 69; -- Collection
UPDATE sub_modules SET icon = 'clock' WHERE id = 70; -- Tracking
UPDATE sub_modules SET icon = 'bar-chart-3' WHERE id = 71; -- Results
UPDATE sub_modules SET icon = 'settings' WHERE id = 72; -- Test Master

-- Inpatient submodules
UPDATE sub_modules SET icon = 'layout-dashboard' WHERE id = 73; -- Inpatient Dashboard
UPDATE sub_modules SET icon = 'bed' WHERE id = 74; -- Bed Management
UPDATE sub_modules SET icon = 'user-plus' WHERE id = 75; -- Admissions
UPDATE sub_modules SET icon = 'zap' WHERE id = 76; -- Transfers
UPDATE sub_modules SET icon = 'users' WHERE id = 77; -- Ward Census

-- Insurance & TPA submodules
UPDATE sub_modules SET icon = 'layout-dashboard' WHERE id = 78; -- Insurance Dashboard
UPDATE sub_modules SET icon = 'shield' WHERE id = 79; -- Pre-Authorization
UPDATE sub_modules SET icon = 'file-text' WHERE id = 80; -- Claims
UPDATE sub_modules SET icon = 'building' WHERE id = 81; -- TPA Management
UPDATE sub_modules SET icon = 'dollar-sign' WHERE id = 82; -- Rate Agreements
UPDATE sub_modules SET icon = 'bar-chart-3' WHERE id = 83; -- Reports

-- Billing submodules
UPDATE sub_modules SET icon = 'layout-dashboard' WHERE id = 84; -- Billing Dashboard
UPDATE sub_modules SET icon = 'credit-card' WHERE id = 85; -- Outpatient Billing
UPDATE sub_modules SET icon = 'credit-card' WHERE id = 86; -- Inpatient Billing
UPDATE sub_modules SET icon = 'shield' WHERE id = 87; -- Insurance Billing
UPDATE sub_modules SET icon = 'zap' WHERE id = 88; -- Quick Billing
UPDATE sub_modules SET icon = 'indian-rupee' WHERE id = 89; -- Cashier
UPDATE sub_modules SET icon = 'package' WHERE id = 90; -- Services
UPDATE sub_modules SET icon = 'file-text' WHERE id = 91; -- Price Lists
UPDATE sub_modules SET icon = 'package' WHERE id = 92; -- Packages
UPDATE sub_modules SET icon = 'target' WHERE id = 93; -- Discounts
UPDATE sub_modules SET icon = 'building' WHERE id = 94; -- Accounts
UPDATE sub_modules SET icon = 'bar-chart-3' WHERE id = 95; -- Reports
UPDATE sub_modules SET icon = 'settings' WHERE id = 96; -- Settings