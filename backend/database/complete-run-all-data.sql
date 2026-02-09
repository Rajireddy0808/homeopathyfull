-- COMPLETE SAMPLE DATA FOR ALL TABLES

-- Insert sample locations
INSERT INTO locations (location_code, name, address, phone, email) VALUES
('LOC001', 'Main Hospital', '123 Hospital Street, City Center, State 12345', '9876543200', 'main@hospital.com'),
('LOC002', 'Branch Clinic North', '456 North Avenue, North District, State 12346', '9876543201', 'north@hospital.com'),
('LOC003', 'Branch Clinic South', '789 South Road, South District, State 12347', '9876543202', 'south@hospital.com');

-- Insert sample users
INSERT INTO users (username, email, password, first_name, last_name, role, location_id, phone, department, specialization, license_number) VALUES
('admin', 'admin@hospital.com', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', 'Admin', 'User', 'admin', 1, '9876543210', 'Administration', NULL, NULL),
('dr.smith', 'dr.smith@hospital.com', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', 'John', 'Smith', 'doctor', 1, '9876543211', 'Cardiology', 'Interventional Cardiology', 'DOC001'),
('dr.johnson', 'dr.johnson@hospital.com', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', 'Sarah', 'Johnson', 'doctor', 2, '9876543212', 'Pediatrics', 'Child Development', 'DOC002'),
('dr.williams', 'dr.williams@hospital.com', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', 'Michael', 'Williams', 'doctor', 1, '9876543213', 'Orthopedics', 'Joint Replacement', 'DOC003'),
('nurse.mary', 'nurse.mary@hospital.com', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', 'Mary', 'Wilson', 'nurse', 1, '9876543214', 'General Ward', NULL, 'NUR001'),
('pharmacist.bob', 'pharmacist.bob@hospital.com', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', 'Bob', 'Anderson', 'pharmacist', 1, '9876543215', 'Pharmacy', NULL, 'PHA001'),
('lab.tech', 'lab.tech@hospital.com', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', 'Lisa', 'Brown', 'lab_technician', 1, '9876543216', 'Laboratory', NULL, 'LAB001'),
('front.desk', 'front.desk@hospital.com', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', 'Emma', 'Davis', 'front_office', 1, '9876543217', 'Front Office', NULL, NULL),
('telecaller1', 'telecaller1@hospital.com', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', 'Mike', 'Taylor', 'telecaller', 1, '9876543218', 'Customer Service', NULL, NULL),
('billing.clerk', 'billing.clerk@hospital.com', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', 'Anna', 'Miller', 'billing', 1, '9876543219', 'Billing', NULL, NULL),
('material.mgr', 'material.mgr@hospital.com', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', 'David', 'Garcia', 'material_manager', 1, '9876543220', 'Material Management', NULL, NULL);

-- Insert sample patients
INSERT INTO patients (patient_id, location_id, first_name, last_name, date_of_birth, gender, phone, email, address, emergency_contact, blood_group, allergies, medical_history, insurance_number) VALUES
('PAT000001', 1, 'James', 'Wilson', '1985-03-15', 'male', '9123456789', 'james.wilson@email.com', '123 Main St, City, State 12345', '9123456790', 'O+', 'Penicillin allergy', 'Hypertension, Diabetes Type 2', 'INS001234567'),
('PAT000002', 1, 'Maria', 'Garcia', '1990-07-22', 'female', '9123456788', 'maria.garcia@email.com', '456 Oak Ave, City, State 12345', '9123456791', 'A+', 'None known', 'Asthma', 'INS001234568'),
('PAT000001', 2, 'Robert', 'Johnson', '1978-11-08', 'male', '9123456787', 'robert.johnson@email.com', '789 Pine St, North District, State 12346', '9123456792', 'B+', 'Shellfish allergy', 'Heart disease family history', NULL),
('PAT000003', 1, 'Jennifer', 'Brown', '1995-05-12', 'female', '9123456786', 'jennifer.brown@email.com', '321 Elm St, City, State 12345', '9123456793', 'AB+', 'Latex allergy', 'None significant', NULL),
('PAT000004', 1, 'Michael', 'Davis', '1982-09-30', 'male', '9123456785', 'michael.davis@email.com', '654 Maple Ave, City, State 12345', '9123456794', 'O-', 'None known', 'Migraine history', 'INS001234570'),
('PAT000005', 1, 'Sarah', 'Thompson', '1988-12-08', 'female', '9123456784', 'sarah.thompson@email.com', '789 Elm Street, City, State 12345', '9123456795', 'A-', 'Dust allergy', 'Thyroid disorder', 'INS001234571'),
('PAT000006', 1, 'David', 'Miller', '1975-06-20', 'male', '9123456783', 'david.miller@email.com', '456 Pine Avenue, City, State 12345', '9123456796', 'B-', 'None known', 'Hypertension', 'INS001234572'),
('PAT000002', 2, 'Lisa', 'Anderson', '1992-09-14', 'female', '9123456782', 'lisa.anderson@email.com', '123 Oak Road, North District, State 12346', '9123456797', 'O+', 'Peanut allergy', 'None significant', NULL),
('PAT000007', 1, 'Mark', 'Taylor', '1980-04-25', 'male', '9123456781', 'mark.taylor@email.com', '321 Maple Street, City, State 12345', '9123456798', 'AB-', 'None known', 'Diabetes Type 1', 'INS001234573'),
('PAT000008', 1, 'Emily', 'White', '1995-11-30', 'female', '9123456780', 'emily.white@email.com', '654 Cedar Avenue, City, State 12345', '9123456799', 'A+', 'Latex allergy', 'Asthma', NULL);

-- Insert sample services
INSERT INTO services (service_code, location_id, name, category, price, description) VALUES
('SRV001', 1, 'General Consultation', 'Consultation', 500.00, 'General physician consultation'),
('SRV002', 1, 'Cardiology Consultation', 'Consultation', 800.00, 'Specialist cardiology consultation'),
('SRV003', 1, 'ECG', 'Diagnostic', 300.00, 'Electrocardiogram test'),
('SRV004', 1, 'X-Ray Chest', 'Radiology', 400.00, 'Chest X-ray examination'),
('SRV005', 1, 'Blood Test', 'Laboratory', 250.00, 'Complete blood count test'),
('SRV006', 1, 'Physiotherapy Session', 'Therapy', 350.00, 'Physical therapy session'),
('SRV007', 1, 'Dietician Consultation', 'Consultation', 400.00, 'Nutritional counseling'),
('SRV008', 1, 'Ultrasound Scan', 'Radiology', 800.00, 'Ultrasound examination'),
('SRV009', 1, 'CT Scan', 'Radiology', 2500.00, 'Computed tomography scan'),
('SRV010', 1, 'MRI Scan', 'Radiology', 5000.00, 'Magnetic resonance imaging'),
('SRV011', 1, 'Endoscopy', 'Procedure', 3000.00, 'Endoscopic examination'),
('SRV012', 1, 'Minor Surgery', 'Surgery', 8000.00, 'Minor surgical procedure'),
('SRV013', 1, 'Dressing', 'Nursing', 150.00, 'Wound dressing service'),
('SRV014', 1, 'Injection', 'Nursing', 50.00, 'Injection administration'),
('SRV015', 1, 'IV Cannulation', 'Nursing', 200.00, 'Intravenous cannula insertion'),
('SRV001', 2, 'General Consultation', 'Consultation', 450.00, 'General physician consultation'),
('SRV002', 2, 'Pediatric Consultation', 'Consultation', 600.00, 'Pediatric specialist consultation'),
('SRV003', 2, 'ECG', 'Diagnostic', 280.00, 'Electrocardiogram test'),
('SRV004', 2, 'X-Ray', 'Radiology', 350.00, 'X-ray examination'),
('SRV005', 2, 'Blood Test', 'Laboratory', 230.00, 'Complete blood count test');

-- Insert sample packages
INSERT INTO packages (package_code, location_id, name, description, total_price, discounted_price) VALUES
('PKG001', 1, 'Basic Health Checkup', 'Complete basic health screening package', 2500.00, 2000.00),
('PKG002', 1, 'Cardiac Screening', 'Comprehensive cardiac health package', 5000.00, 4200.00),
('PKG003', 1, 'Diabetes Management Package', 'Comprehensive diabetes care package', 3500.00, 2800.00),
('PKG004', 1, 'Women Health Checkup', 'Complete health screening for women', 4000.00, 3200.00),
('PKG005', 1, 'Senior Citizen Package', 'Health checkup package for elderly', 3000.00, 2400.00),
('PKG006', 1, 'Pre-Employment Checkup', 'Medical fitness certificate package', 1500.00, 1200.00),
('PKG001', 2, 'Basic Health Checkup', 'Complete basic health screening package', 2200.00, 1800.00),
('PKG002', 2, 'Child Health Package', 'Comprehensive child health package', 2800.00, 2300.00);

-- Insert sample package services
INSERT INTO package_services (package_id, service_id, quantity) VALUES
(1, 1, 1), (1, 3, 1), (1, 5, 1),
(2, 2, 1), (2, 3, 1), (2, 4, 1),
(3, 1, 1), (3, 2, 1), (3, 5, 1),
(4, 1, 1), (4, 8, 1), (4, 5, 1),
(5, 1, 1), (5, 3, 1), (5, 4, 1),
(6, 1, 1), (6, 4, 1), (6, 5, 1),
(7, 16, 1), (7, 18, 1), (7, 20, 1),
(8, 17, 1), (8, 18, 1), (8, 20, 1);

-- Insert sample discounts
INSERT INTO discounts (discount_code, location_id, name, type, value, min_amount, max_discount, valid_from, valid_to) VALUES
('SENIOR10', 1, 'Senior Citizen Discount', 'percentage', 10.00, 500.00, 1000.00, '2024-01-01', '2024-12-31'),
('STAFF20', 1, 'Staff Discount', 'percentage', 20.00, 100.00, 2000.00, '2024-01-01', '2024-12-31'),
('NEWPATIENT', 1, 'New Patient Discount', 'fixed', 100.00, 1000.00, 100.00, '2024-01-01', '2024-12-31'),
('EMERGENCY', 1, 'Emergency Discount', 'percentage', 15.00, 1000.00, 500.00, '2024-01-01', '2024-12-31'),
('FAMILY', 1, 'Family Package Discount', 'fixed', 200.00, 2000.00, 200.00, '2024-01-01', '2024-12-31'),
('STUDENT', 1, 'Student Discount', 'percentage', 25.00, 500.00, 300.00, '2024-01-01', '2024-12-31'),
('CORPORATE', 1, 'Corporate Discount', 'percentage', 12.00, 2000.00, 1500.00, '2024-01-01', '2024-12-31'),
('SENIOR10', 2, 'Senior Citizen Discount', 'percentage', 10.00, 400.00, 800.00, '2024-01-01', '2024-12-31'),
('STAFF15', 2, 'Staff Discount', 'percentage', 15.00, 100.00, 1500.00, '2024-01-01', '2024-12-31');

-- Insert sample medicines
INSERT INTO medicines (medicine_code, location_id, name, generic_name, manufacturer, category, unit_price, stock_quantity, min_stock_level, expiry_date, batch_number) VALUES
('MED001', 1, 'Paracetamol 500mg', 'Paracetamol', 'PharmaCorp', 'Analgesic', 2.50, 1000, 100, '2025-12-31', 'BATCH001'),
('MED002', 1, 'Amoxicillin 250mg', 'Amoxicillin', 'MediLab', 'Antibiotic', 15.75, 500, 50, '2025-06-30', 'BATCH002'),
('MED003', 1, 'Metformin 500mg', 'Metformin HCl', 'DiabetCare', 'Antidiabetic', 8.25, 800, 80, '2025-09-15', 'BATCH003'),
('MED004', 1, 'Lisinopril 10mg', 'Lisinopril', 'CardioMed', 'ACE Inhibitor', 12.50, 300, 30, '2025-11-20', 'BATCH004'),
('MED005', 1, 'Omeprazole 20mg', 'Omeprazole', 'GastroPharm', 'PPI', 18.90, 400, 40, '2025-08-10', 'BATCH005'),
('MED006', 1, 'Aspirin 75mg', 'Aspirin', 'CardioMed', 'Antiplatelet', 3.50, 600, 60, '2025-10-15', 'BATCH006'),
('MED007', 1, 'Azithromycin 500mg', 'Azithromycin', 'Cipla', 'Antibiotic', 45.00, 300, 30, '2025-07-15', 'BATCH007'),
('MED008', 1, 'Cetirizine 10mg', 'Cetirizine', 'Dr Reddys', 'Antihistamine', 3.25, 500, 50, '2025-11-30', 'BATCH008'),
('MED009', 1, 'Diclofenac 50mg', 'Diclofenac', 'Novartis', 'NSAID', 6.75, 400, 40, '2025-09-10', 'BATCH009'),
('MED010', 1, 'Ranitidine 150mg', 'Ranitidine', 'GSK', 'H2 Blocker', 4.50, 600, 60, '2025-08-20', 'BATCH010'),
('MED011', 1, 'Salbutamol Inhaler', 'Salbutamol', 'Cipla', 'Bronchodilator', 125.00, 150, 15, '2025-12-05', 'BATCH011'),
('MED012', 1, 'Insulin Regular', 'Human Insulin', 'Novo Nordisk', 'Antidiabetic', 380.00, 80, 8, '2025-06-25', 'BATCH012'),
('MED001', 2, 'Paracetamol 500mg', 'Paracetamol', 'PharmaCorp', 'Analgesic', 2.50, 800, 80, '2025-12-31', 'BATCH013'),
('MED002', 2, 'Amoxicillin 250mg', 'Amoxicillin', 'MediLab', 'Antibiotic', 15.75, 400, 40, '2025-06-30', 'BATCH014'),
('MED008', 2, 'Cetirizine 10mg', 'Cetirizine', 'Dr Reddys', 'Antihistamine', 3.25, 300, 30, '2025-11-30', 'BATCH015');

-- Insert sample lab tests
INSERT INTO lab_tests (test_code, location_id, test_name, category, price, normal_range, unit, sample_type) VALUES
('LAB001', 1, 'Complete Blood Count', 'Hematology', 250.00, 'Various parameters', 'Multiple', 'Blood'),
('LAB002', 1, 'Blood Glucose Fasting', 'Biochemistry', 150.00, '70-100', 'mg/dL', 'Blood'),
('LAB003', 1, 'Lipid Profile', 'Biochemistry', 400.00, 'Various parameters', 'mg/dL', 'Blood'),
('LAB004', 1, 'Thyroid Function Test', 'Endocrinology', 500.00, 'TSH: 0.4-4.0', 'mIU/L', 'Blood'),
('LAB005', 1, 'Liver Function Test', 'Biochemistry', 350.00, 'Various parameters', 'U/L', 'Blood'),
('LAB006', 1, 'Urine Routine', 'Pathology', 200.00, 'Normal', 'Various', 'Urine'),
('LAB007', 1, 'HbA1c', 'Biochemistry', 300.00, '4.0-5.6%', '%', 'Blood'),
('LAB008', 1, 'Creatinine', 'Biochemistry', 120.00, '0.6-1.2', 'mg/dL', 'Blood'),
('LAB009', 1, 'ESR', 'Hematology', 80.00, '0-20', 'mm/hr', 'Blood'),
('LAB010', 1, 'CRP', 'Immunology', 200.00, '<3.0', 'mg/L', 'Blood'),
('LAB011', 1, 'Vitamin D', 'Biochemistry', 800.00, '30-100', 'ng/mL', 'Blood'),
('LAB012', 1, 'Vitamin B12', 'Biochemistry', 600.00, '200-900', 'pg/mL', 'Blood'),
('LAB013', 1, 'Stool Routine', 'Pathology', 150.00, 'Normal', 'Various', 'Stool'),
('LAB014', 1, 'Pregnancy Test', 'Immunology', 100.00, 'Negative/Positive', 'Qualitative', 'Urine'),
('LAB001', 2, 'Complete Blood Count', 'Hematology', 230.00, 'Various parameters', 'Multiple', 'Blood'),
('LAB002', 2, 'Blood Glucose Fasting', 'Biochemistry', 140.00, '70-100', 'mg/dL', 'Blood'),
('LAB006', 2, 'Urine Routine', 'Pathology', 180.00, 'Normal', 'Various', 'Urine');

-- Insert sample beds
INSERT INTO beds (bed_number, location_id, ward, bed_type, price_per_day) VALUES
('ICU-001', 1, 'ICU', 'icu', 5000.00),
('ICU-002', 1, 'ICU', 'icu', 5000.00),
('ICU-003', 1, 'ICU', 'icu', 5000.00),
('GEN-001', 1, 'General Ward A', 'general', 1500.00),
('GEN-002', 1, 'General Ward A', 'general', 1500.00),
('GEN-003', 1, 'General Ward B', 'general', 1500.00),
('GEN-004', 1, 'General Ward B', 'general', 1500.00),
('GEN-005', 1, 'General Ward C', 'general', 1500.00),
('PVT-001', 1, 'Private Ward', 'private', 3000.00),
('PVT-002', 1, 'Private Ward', 'private', 3000.00),
('PVT-003', 1, 'Private Ward', 'private', 3000.00),
('EMR-001', 1, 'Emergency', 'emergency', 2000.00),
('EMR-002', 1, 'Emergency', 'emergency', 2000.00),
('EMR-003', 1, 'Emergency', 'emergency', 2000.00),
('ICU-001', 2, 'ICU North', 'icu', 4500.00),
('ICU-002', 2, 'ICU North', 'icu', 4500.00),
('GEN-001', 2, 'General Ward North', 'general', 1300.00),
('GEN-002', 2, 'General Ward North', 'general', 1300.00),
('PVT-001', 2, 'Private Ward North', 'private', 2800.00),
('EMR-001', 2, 'Emergency North', 'emergency', 1800.00);

-- Insert sample insurance companies
INSERT INTO insurance_companies (name, code, contact_person, phone, email, address) VALUES
('National Health Insurance', 'NHI', 'John Manager', '9876543220', 'contact@nhi.com', '100 Insurance Plaza, City'),
('Star Health Insurance', 'STAR', 'Sarah Director', '9876543221', 'info@starhealth.com', '200 Health Tower, City'),
('HDFC ERGO Health', 'HDFC', 'Mike Executive', '9876543222', 'support@hdfcergo.com', '300 HDFC Building, City'),
('ICICI Lombard Health', 'ICICI', 'Lisa Coordinator', '9876543223', 'help@icicilombard.com', '400 ICICI Center, City'),
('Max Bupa Health', 'MAXBUPA', 'Robert Manager', '9876543224', 'care@maxbupa.com', '500 Max Tower, City'),
('Care Health Insurance', 'CARE', 'Jennifer Head', '9876543225', 'support@careinsurance.com', '600 Care Plaza, City');

-- Insert sample TPA companies
INSERT INTO tpa_companies (name, code, contact_person, phone, email, address) VALUES
('MediAssist TPA', 'MEDI', 'Robert TPA Manager', '9876543226', 'contact@mediassist.com', '700 TPA Plaza, City'),
('Vidal Health TPA', 'VIDAL', 'Jennifer TPA Head', '9876543227', 'info@vidalhealth.com', '800 Vidal Tower, City'),
('Paramount TPA', 'PARAM', 'David TPA Director', '9876543228', 'support@paramounttpa.com', '900 Paramount Building, City'),
('Good Health TPA', 'GOODH', 'Maria TPA Manager', '9876543229', 'help@goodhealthtpa.com', '1000 Good Health Center, City');

-- Insert sample insurance rates
INSERT INTO insurance_rates (location_id, insurance_company_id, service_id, coverage_percentage, max_coverage_amount) VALUES
(1, 1, 1, 80.00, 400.00), (1, 1, 2, 70.00, 560.00), (1, 1, 3, 100.00, 300.00),
(1, 2, 1, 90.00, 450.00), (1, 2, 2, 75.00, 600.00), (1, 2, 3, 100.00, 300.00),
(1, 3, 1, 85.00, 425.00), (1, 3, 2, 80.00, 640.00), (1, 3, 4, 90.00, 360.00),
(1, 4, 1, 75.00, 375.00), (1, 4, 2, 70.00, 560.00), (1, 4, 5, 100.00, 250.00),
(2, 1, 16, 80.00, 360.00), (2, 1, 17, 75.00, 450.00), (2, 2, 16, 90.00, 405.00);

-- Insert sample vendors
INSERT INTO vendors (vendor_code, location_id, name, contact_person, phone, email, address, gst_number, pan_number) VALUES
('VEN001', 1, 'MedSupply Corp', 'Alex Johnson', '9876543230', 'alex@medsupply.com', '1100 Supply Street, City', 'GST123456789', 'PAN123456'),
('VEN002', 1, 'HealthEquip Ltd', 'Maria Rodriguez', '9876543231', 'maria@healthequip.com', '1200 Equipment Ave, City', 'GST987654321', 'PAN987654'),
('VEN003', 1, 'PharmaDist Inc', 'Carlos Martinez', '9876543232', 'carlos@pharmadist.com', '1300 Pharma Road, City', 'GST456789123', 'PAN456789'),
('VEN004', 1, 'BioMed Solutions', 'Dr. Rajesh Kumar', '9876543233', 'rajesh@biomed.com', '1400 Medical Plaza, City', 'GST789123456', 'PAN789123'),
('VEN005', 1, 'TechCare Equipment', 'Ms. Priya Sharma', '9876543234', 'priya@techcare.com', '1500 Tech Street, City', 'GST321654987', 'PAN321654'),
('VEN006', 2, 'North Medical Supply', 'Mr. Amit Patel', '9876543235', 'amit@northmed.com', '1600 North Avenue, North City', 'GST654321789', 'PAN654321'),
('VEN007', 1, 'Surgical Instruments Co', 'Dr. Neha Singh', '9876543236', 'neha@surgicalinst.com', '1700 Surgical Street, City', 'GST147258369', 'PAN147258'),
('VEN008', 1, 'Laboratory Solutions', 'Mr. Vikram Gupta', '9876543237', 'vikram@labsolutions.com', '1800 Lab Avenue, City', 'GST963852741', 'PAN963852');

-- Insert sample items
INSERT INTO items (item_code, location_id, name, category, unit, unit_price, stock_quantity, min_stock_level) VALUES
('ITM001', 1, 'Surgical Gloves', 'Medical Supplies', 'Box', 150.00, 500, 50),
('ITM002', 1, 'Syringes 5ml', 'Medical Supplies', 'Pack', 75.00, 1000, 100),
('ITM003', 1, 'Bandages', 'Medical Supplies', 'Roll', 25.00, 200, 20),
('ITM004', 1, 'Cotton Swabs', 'Medical Supplies', 'Pack', 30.00, 300, 30),
('ITM005', 1, 'Surgical Masks', 'Medical Supplies', 'Box', 120.00, 400, 40),
('ITM006', 1, 'Thermometer Digital', 'Medical Equipment', 'Piece', 250.00, 50, 5),
('ITM007', 1, 'Blood Pressure Monitor', 'Medical Equipment', 'Piece', 1500.00, 20, 2),
('ITM008', 1, 'Stethoscope', 'Medical Equipment', 'Piece', 800.00, 30, 3),
('ITM009', 1, 'Pulse Oximeter', 'Medical Equipment', 'Piece', 1200.00, 25, 3),
('ITM010', 1, 'Wheelchair', 'Medical Equipment', 'Piece', 5000.00, 10, 1),
('ITM011', 1, 'Hospital Bed', 'Furniture', 'Piece', 25000.00, 5, 1),
('ITM012', 1, 'IV Stand', 'Medical Equipment', 'Piece', 800.00, 15, 2),
('ITM013', 1, 'Oxygen Cylinder', 'Medical Equipment', 'Piece', 3500.00, 8, 2),
('ITM014', 1, 'Nebulizer', 'Medical Equipment', 'Piece', 2200.00, 12, 2),
('ITM015', 1, 'ECG Machine', 'Medical Equipment', 'Piece', 45000.00, 3, 1),
('ITM001', 2, 'Surgical Gloves', 'Medical Supplies', 'Box', 140.00, 300, 30),
('ITM002', 2, 'Syringes 5ml', 'Medical Supplies', 'Pack', 70.00, 600, 60),
('ITM003', 2, 'Bandages', 'Medical Supplies', 'Roll', 23.00, 150, 15);

-- Continue with more sample data in next part...