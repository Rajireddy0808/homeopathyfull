-- COMPREHENSIVE SAMPLE DATA FOR ALL HIMS TABLES
-- This file contains sample data for every table in the HIMS database

-- Sample appointments
INSERT INTO appointments (appointment_number, location_id, patient_id, doctor_id, appointment_date, type, status, reason, consultation_fee) VALUES
('APT000001', 1, 1, 2, '2024-01-15 09:00:00', 'consultation', 'completed', 'Chest pain', 800.00),
('APT000002', 1, 2, 4, '2024-01-15 10:30:00', 'follow_up', 'completed', 'Diabetes follow-up', 500.00),
('APT000003', 1, 3, 2, '2024-01-16 14:00:00', 'consultation', 'scheduled', 'Hypertension check', 800.00),
('APT000004', 2, 4, 3, '2024-01-16 11:00:00', 'routine_checkup', 'confirmed', 'Annual checkup', 600.00),
('APT000005', 1, 5, 4, '2024-01-17 15:30:00', 'emergency', 'in_progress', 'Severe headache', 500.00);

-- Sample vitals
INSERT INTO vitals (location_id, patient_id, appointment_id, recorded_by, height, weight, bmi, temperature, blood_pressure_systolic, blood_pressure_diastolic, pulse_rate, respiratory_rate, oxygen_saturation, blood_sugar) VALUES
(1, 1, 1, 5, 175.0, 75.5, 24.7, 98.6, 140, 90, 78, 18, 98.5, 110.0),
(1, 2, 2, 5, 162.0, 58.2, 22.2, 98.4, 120, 80, 72, 16, 99.0, 95.0),
(1, 3, NULL, 5, 180.0, 82.0, 25.3, 99.1, 150, 95, 85, 20, 97.8, 180.0),
(2, 4, 4, 5, 168.0, 65.0, 23.0, 98.2, 110, 70, 68, 15, 99.2, 88.0),
(1, 5, 5, 5, 170.0, 70.0, 24.2, 100.2, 160, 100, 90, 22, 96.5, 200.0);

-- Sample bills
INSERT INTO bills (bill_number, location_id, patient_id, appointment_id, total_amount, discount_amount, tax_amount, net_amount, paid_amount, status, payment_method, created_by) VALUES
('BILL000001', 1, 1, 1, 1100.00, 100.00, 150.00, 1150.00, 1150.00, 'paid', 'card', 10),
('BILL000002', 1, 2, 2, 750.00, 0.00, 112.50, 862.50, 862.50, 'paid', 'cash', 10),
('BILL000003', 1, 3, NULL, 2500.00, 200.00, 345.00, 2645.00, 1000.00, 'partially_paid', 'upi', 10),
('BILL000004', 2, 4, 4, 830.00, 83.00, 112.05, 859.05, 859.05, 'paid', 'insurance', 10),
('BILL000005', 1, 5, 5, 1200.00, 0.00, 180.00, 1380.00, 0.00, 'pending', NULL, 10);

-- Sample bill items
INSERT INTO bill_items (bill_id, item_name, item_code, quantity, unit_price, total_price, category) VALUES
(1, 'Cardiology Consultation', 'SRV002', 1, 800.00, 800.00, 'Consultation'),
(1, 'ECG', 'SRV003', 1, 300.00, 300.00, 'Diagnostic'),
(2, 'General Consultation', 'SRV001', 1, 500.00, 500.00, 'Consultation'),
(2, 'Blood Test', 'SRV005', 1, 250.00, 250.00, 'Laboratory'),
(3, 'Basic Health Checkup', 'PKG001', 1, 2500.00, 2500.00, 'Package'),
(4, 'Pediatric Consultation', 'SRV002', 1, 600.00, 600.00, 'Consultation'),
(4, 'Blood Test', 'SRV005', 1, 230.00, 230.00, 'Laboratory'),
(5, 'General Consultation', 'SRV001', 1, 500.00, 500.00, 'Consultation'),
(5, 'CT Scan', 'SRV009', 1, 2500.00, 2500.00, 'Radiology');

-- Sample prescriptions
INSERT INTO prescriptions (prescription_number, location_id, patient_id, doctor_id, appointment_id, status, notes) VALUES
('PRE000001', 1, 1, 2, 1, 'dispensed', 'Take medications as prescribed'),
('PRE000002', 1, 2, 4, 2, 'dispensed', 'Continue diabetes medication'),
('PRE000003', 1, 3, 2, NULL, 'pending', 'New prescription for hypertension'),
('PRE000004', 2, 4, 3, 4, 'dispensed', 'Routine medication'),
('PRE000005', 1, 5, 4, 5, 'pending', 'Pain management medication');

-- Sample prescription items
INSERT INTO prescription_items (prescription_id, medicine_id, quantity, dosage, frequency, duration, instructions) VALUES
(1, 1, 30, '500mg', 'Twice daily', 15, 'Take after meals'),
(1, 6, 30, '75mg', 'Once daily', 30, 'Take in morning'),
(2, 3, 60, '500mg', 'Twice daily', 30, 'Take before meals'),
(2, 1, 20, '500mg', 'As needed', 10, 'For fever or pain'),
(3, 4, 30, '10mg', 'Once daily', 30, 'Take in morning'),
(4, 8, 10, '10mg', 'Once daily', 10, 'For allergy'),
(5, 9, 20, '50mg', 'Twice daily', 10, 'Take with food');

-- Sample prescription templates
INSERT INTO prescription_templates (template_name, location_id, doctor_id, diagnosis, template_data) VALUES
('Hypertension Standard', 1, 2, 'Essential Hypertension', '{"medicines": [{"id": 4, "dosage": "10mg", "frequency": "Once daily", "duration": 30}]}'),
('Diabetes Type 2', 1, 4, 'Type 2 Diabetes Mellitus', '{"medicines": [{"id": 3, "dosage": "500mg", "frequency": "Twice daily", "duration": 30}]}'),
('Common Cold', 1, 2, 'Upper Respiratory Tract Infection', '{"medicines": [{"id": 1, "dosage": "500mg", "frequency": "Twice daily", "duration": 5}, {"id": 8, "dosage": "10mg", "frequency": "Once daily", "duration": 5}]}');

-- Sample pharmacy sales
INSERT INTO pharmacy_sales (sale_number, location_id, patient_id, prescription_id, total_amount, discount_amount, net_amount, payment_method, sold_by) VALUES
('SALE000001', 1, 1, 1, 180.00, 18.00, 162.00, 'cash', 6),
('SALE000002', 1, 2, 2, 525.00, 0.00, 525.00, 'card', 6),
('SALE000003', 2, 4, 4, 32.50, 3.25, 29.25, 'upi', 6),
('SALE000004', 1, NULL, NULL, 75.00, 0.00, 75.00, 'cash', 6),
('SALE000005', 1, 5, 5, 135.00, 13.50, 121.50, 'card', 6);

-- Sample pharmacy sale items
INSERT INTO pharmacy_sale_items (sale_id, medicine_id, quantity, unit_price, total_price) VALUES
(1, 1, 30, 2.50, 75.00), (1, 6, 30, 3.50, 105.00),
(2, 3, 60, 8.25, 495.00), (2, 1, 12, 2.50, 30.00),
(3, 8, 10, 3.25, 32.50),
(4, 1, 30, 2.50, 75.00),
(5, 9, 20, 6.75, 135.00);

-- Sample lab orders
INSERT INTO lab_orders (order_number, location_id, patient_id, doctor_id, appointment_id, status, collection_date, report_date, notes) VALUES
('LAB000001', 1, 1, 2, 1, 'completed', '2024-01-15 10:00:00', '2024-01-15 16:00:00', 'Cardiac workup'),
('LAB000002', 1, 2, 4, 2, 'completed', '2024-01-15 11:00:00', '2024-01-15 17:00:00', 'Diabetes monitoring'),
('LAB000003', 1, 3, 2, NULL, 'processing', '2024-01-16 09:00:00', NULL, 'Routine checkup'),
('LAB000004', 2, 4, 3, 4, 'completed', '2024-01-16 10:00:00', '2024-01-16 15:00:00', 'Annual screening'),
('LAB000005', 1, 5, 4, 5, 'ordered', NULL, NULL, 'Emergency workup');

-- Sample lab order items
INSERT INTO lab_order_items (order_id, test_id, result, status, remarks) VALUES
(1, 1, 'WBC: 7500, RBC: 4.5M, Hgb: 14.2', 'completed', 'Normal values'),
(1, 3, 'Total Cholesterol: 220, HDL: 45, LDL: 140', 'completed', 'Borderline high'),
(2, 2, '95 mg/dL', 'completed', 'Normal fasting glucose'),
(2, 7, '6.8%', 'completed', 'Good diabetic control'),
(3, 1, NULL, 'pending', NULL),
(3, 6, NULL, 'pending', NULL),
(4, 15, 'Negative', 'completed', 'Normal'),
(4, 16, '88 mg/dL', 'completed', 'Normal'),
(5, 1, NULL, 'pending', NULL);

-- Sample admissions
INSERT INTO admissions (admission_number, location_id, patient_id, bed_id, doctor_id, admission_date, status, admission_type, diagnosis, notes) VALUES
('ADM000001', 1, 1, 1, 2, '2024-01-15 20:00:00', 'admitted', 'emergency', 'Acute Myocardial Infarction', 'Patient stable, monitoring required'),
('ADM000002', 1, 3, 9, 4, '2024-01-16 08:00:00', 'admitted', 'planned', 'Diabetes management', 'Planned admission for glucose control'),
('ADM000003', 2, 4, 17, 3, '2024-01-16 12:00:00', 'discharged', 'emergency', 'Acute Gastroenteritis', 'Discharged after treatment'),
('ADM000004', 1, 5, 12, 4, '2024-01-17 16:00:00', 'admitted', 'emergency', 'Severe Migraine', 'Under observation');

-- Sample bed transfers
INSERT INTO bed_transfers (admission_id, from_bed_id, to_bed_id, transfer_date, reason, transferred_by) VALUES
(1, 12, 1, '2024-01-15 22:00:00', 'Patient condition deteriorated, moved to ICU', 5),
(2, 4, 9, '2024-01-16 10:00:00', 'Patient requested private room', 5);

-- Sample pre-authorizations
INSERT INTO pre_authorizations (auth_number, location_id, patient_id, insurance_company_id, requested_amount, approved_amount, status, valid_from, valid_to, diagnosis, treatment_plan, created_by) VALUES
('AUTH000001', 1, 1, 1, 50000.00, 40000.00, 'approved', '2024-01-15', '2024-02-15', 'Cardiac Surgery', 'Angioplasty procedure', 8),
('AUTH000002', 1, 2, 2, 25000.00, 25000.00, 'approved', '2024-01-16', '2024-02-16', 'Diabetes Management', 'Inpatient glucose control', 8),
('AUTH000003', 1, 5, 3, 15000.00, NULL, 'pending', '2024-01-17', '2024-02-17', 'Neurological Assessment', 'MRI and specialist consultation', 8);

-- Sample insurance claims
INSERT INTO insurance_claims (claim_number, location_id, patient_id, insurance_company_id, bill_id, pre_auth_id, claim_amount, approved_amount, status, submission_date, approval_date, remarks) VALUES
('CLM000001', 1, 1, 1, 1, 1, 1150.00, 920.00, 'approved', '2024-01-15 18:00:00', '2024-01-16 10:00:00', '80% coverage applied'),
('CLM000002', 2, 4, 2, 4, NULL, 859.05, 773.15, 'paid', '2024-01-16 16:00:00', '2024-01-17 09:00:00', '90% coverage, payment processed'),
('CLM000003', 1, 2, 2, 2, 2, 862.50, NULL, 'under_review', '2024-01-17 12:00:00', NULL, 'Documents under verification');

-- Sample purchase orders
INSERT INTO purchase_orders (po_number, location_id, vendor_id, total_amount, status, order_date, expected_delivery_date, created_by) VALUES
('PO000001', 1, 1, 25000.00, 'received', '2024-01-10', '2024-01-15', 11),
('PO000002', 1, 2, 45000.00, 'approved', '2024-01-12', '2024-01-18', 11),
('PO000003', 1, 3, 15000.00, 'sent', '2024-01-14', '2024-01-20', 11),
('PO000004', 2, 6, 18000.00, 'draft', '2024-01-16', '2024-01-22', 11);

-- Sample purchase order items
INSERT INTO purchase_order_items (po_id, item_id, quantity, unit_price, total_price) VALUES
(1, 1, 100, 150.00, 15000.00), (1, 2, 50, 75.00, 3750.00), (1, 3, 250, 25.00, 6250.00),
(2, 15, 1, 45000.00, 45000.00),
(3, 6, 20, 250.00, 5000.00), (3, 7, 5, 1500.00, 7500.00), (3, 8, 3, 800.00, 2400.00),
(4, 16, 50, 140.00, 7000.00), (4, 17, 100, 70.00, 7000.00), (4, 18, 100, 23.00, 2300.00);

-- Sample GRN
INSERT INTO grn (grn_number, location_id, po_id, vendor_id, invoice_number, invoice_date, total_amount, received_by) VALUES
('GRN000001', 1, 1, 1, 'INV-2024-001', '2024-01-15', 25000.00, 11),
('GRN000002', 1, 2, 2, 'INV-2024-002', '2024-01-18', 45000.00, 11);

-- Sample GRN items
INSERT INTO grn_items (grn_id, item_id, ordered_quantity, received_quantity, unit_price, total_price) VALUES
(1, 1, 100, 100, 150.00, 15000.00), (1, 2, 50, 50, 75.00, 3750.00), (1, 3, 250, 250, 25.00, 6250.00),
(2, 15, 1, 1, 45000.00, 45000.00);

-- Sample stock adjustments
INSERT INTO stock_adjustments (adjustment_number, location_id, item_id, adjustment_type, quantity, reason, adjusted_by) VALUES
('ADJ000001', 1, 1, 'increase', 50, 'Stock received from GRN', 11),
('ADJ000002', 1, 6, 'decrease', 2, 'Damaged items', 11),
('ADJ000003', 1, 10, 'increase', 5, 'Found during stock audit', 11);

-- Sample stock transfers
INSERT INTO stock_transfers (transfer_number, from_location_id, to_location_id, status, transfer_date, transferred_by) VALUES
('TRF000001', 1, 2, 'received', '2024-01-16 10:00:00', 11),
('TRF000002', 1, 3, 'in_transit', '2024-01-17 14:00:00', 11);

-- Sample stock transfer items
INSERT INTO stock_transfer_items (transfer_id, item_id, quantity, received_quantity) VALUES
(1, 1, 50, 50), (1, 2, 30, 30), (1, 3, 100, 100),
(2, 6, 10, 0), (2, 8, 5, 0);

-- Sample doctor schedules
INSERT INTO doctor_schedules (doctor_id, location_id, day_of_week, start_time, end_time) VALUES
(2, 1, 1, '09:00:00', '17:00:00'), (2, 1, 2, '09:00:00', '17:00:00'), (2, 1, 3, '09:00:00', '17:00:00'),
(3, 2, 1, '10:00:00', '18:00:00'), (3, 2, 2, '10:00:00', '18:00:00'), (3, 2, 4, '10:00:00', '18:00:00'),
(4, 1, 1, '08:00:00', '16:00:00'), (4, 1, 3, '08:00:00', '16:00:00'), (4, 1, 5, '08:00:00', '16:00:00');

-- Sample doctor rounds
INSERT INTO doctor_rounds (round_number, location_id, doctor_id, round_date, start_time, end_time, notes) VALUES
('RND000001', 1, 2, '2024-01-15', '2024-01-15 08:00:00', '2024-01-15 10:00:00', 'Morning rounds completed'),
('RND000002', 1, 4, '2024-01-16', '2024-01-16 07:30:00', '2024-01-16 09:30:00', 'All patients stable'),
('RND000003', 2, 3, '2024-01-16', '2024-01-16 08:00:00', '2024-01-16 09:00:00', 'Pediatric ward rounds');

-- Sample doctor round patients
INSERT INTO doctor_round_patients (round_id, patient_id, admission_id, visit_order, notes, visited_at) VALUES
(1, 1, 1, 1, 'Patient responding well to treatment', '2024-01-15 08:15:00'),
(1, 3, 2, 2, 'Glucose levels improving', '2024-01-15 08:45:00'),
(2, 1, 1, 1, 'Continue current medication', '2024-01-16 07:45:00'),
(2, 3, 2, 2, 'Ready for discharge tomorrow', '2024-01-16 08:15:00'),
(3, 4, 3, 1, 'Patient discharged', '2024-01-16 08:30:00');

-- Sample communications
INSERT INTO communications (location_id, from_user_id, to_user_id, patient_id, subject, message, priority, is_read) VALUES
(1, 2, 5, 1, 'Patient Care Update', 'Please monitor patient vitals every 2 hours', 'high', false),
(1, 4, 6, 2, 'Medication Adjustment', 'Please prepare new prescription for patient', 'normal', true),
(1, 8, 2, 3, 'Insurance Approval', 'Pre-authorization approved for patient treatment', 'normal', false),
(2, 3, 5, 4, 'Discharge Planning', 'Patient ready for discharge, prepare documents', 'normal', true);

-- Sample telecaller campaigns
INSERT INTO telecaller_campaigns (campaign_name, location_id, description, start_date, end_date, status, created_by) VALUES
('Appointment Reminders Jan 2024', 1, 'Monthly appointment reminder campaign', '2024-01-01', '2024-01-31', 'active', 9),
('Health Checkup Follow-up', 1, 'Follow-up with patients for annual checkups', '2024-01-15', '2024-02-15', 'active', 9),
('Payment Due Reminders', 2, 'Reminder calls for pending payments', '2024-01-10', '2024-01-25', 'completed', 9);

-- Sample telecaller follow-ups
INSERT INTO telecaller_followups (location_id, patient_id, telecaller_id, campaign_id, follow_up_type, scheduled_date, completed_date, status, notes, outcome) VALUES
(1, 1, 9, 1, 'appointment_reminder', '2024-01-14 10:00:00', '2024-01-14 10:15:00', 'completed', 'Reminded about cardiac follow-up', 'Patient confirmed appointment'),
(1, 2, 9, 2, 'health_checkup', '2024-01-16 14:00:00', '2024-01-16 14:10:00', 'completed', 'Annual checkup reminder', 'Patient scheduled appointment'),
(2, 4, 9, 3, 'payment_due', '2024-01-15 11:00:00', '2024-01-15 11:05:00', 'completed', 'Payment reminder call', 'Patient made payment'),
(1, 3, 9, 1, 'appointment_reminder', '2024-01-17 15:00:00', NULL, 'pending', 'Scheduled reminder call', NULL);

-- Sample patient queue
INSERT INTO patient_queue (location_id, patient_id, appointment_id, queue_number, queue_type, status, estimated_time, actual_time) VALUES
(1, 1, 1, 1, 'consultation', 'completed', '2024-01-15 09:00:00', '2024-01-15 09:15:00'),
(1, 2, 2, 2, 'consultation', 'completed', '2024-01-15 10:30:00', '2024-01-15 10:45:00'),
(1, 3, 3, 1, 'consultation', 'waiting', '2024-01-16 14:00:00', NULL),
(2, 4, 4, 1, 'consultation', 'completed', '2024-01-16 11:00:00', '2024-01-16 11:20:00'),
(1, 5, 5, 1, 'consultation', 'in_progress', '2024-01-17 15:30:00', '2024-01-17 15:35:00');

-- Sample system settings
INSERT INTO system_settings (location_id, setting_key, setting_value, description, updated_by) VALUES
(1, 'appointment_slot_duration', '30', 'Default appointment slot duration in minutes', 1),
(1, 'max_appointments_per_day', '50', 'Maximum appointments per doctor per day', 1),
(1, 'auto_generate_patient_id', 'true', 'Automatically generate patient IDs', 1),
(1, 'default_consultation_fee', '500', 'Default consultation fee amount', 1),
(1, 'enable_sms_reminders', 'true', 'Enable SMS appointment reminders', 1),
(2, 'appointment_slot_duration', '30', 'Default appointment slot duration in minutes', 1),
(2, 'max_appointments_per_day', '40', 'Maximum appointments per doctor per day', 1),
(2, 'default_consultation_fee', '450', 'Default consultation fee amount', 1);

-- Sample central pharmacy items
INSERT INTO central_pharmacy_items (item_code, location_id, name, generic_name, manufacturer, category, unit_price, stock_quantity, min_stock_level, max_stock_level, expiry_date, batch_number, rack_location) VALUES
('CPI001', 1, 'Paracetamol 500mg Bulk', 'Paracetamol', 'PharmaCorp', 'Analgesic', 2.00, 5000, 500, 10000, '2025-12-31', 'CBATCH001', 'A1-01'),
('CPI002', 1, 'Amoxicillin 250mg Bulk', 'Amoxicillin', 'MediLab', 'Antibiotic', 12.50, 2000, 200, 5000, '2025-06-30', 'CBATCH002', 'A1-02'),
('CPI003', 1, 'Metformin 500mg Bulk', 'Metformin HCl', 'DiabetCare', 'Antidiabetic', 6.75, 3000, 300, 8000, '2025-09-15', 'CBATCH003', 'A2-01'),
('CPI004', 1, 'Insulin Regular Bulk', 'Human Insulin', 'Novo Nordisk', 'Antidiabetic', 320.00, 200, 20, 500, '2025-06-25', 'CBATCH004', 'B1-01');

-- Sample pharmacy indents
INSERT INTO pharmacy_indents (indent_number, location_id, requested_by, approved_by, status, total_amount, request_date, required_date, notes) VALUES
('IND000001', 1, 6, 11, 'approved', 15000.00, '2024-01-10', '2024-01-15', 'Monthly stock replenishment'),
('IND000002', 2, 6, 11, 'ordered', 8000.00, '2024-01-12', '2024-01-18', 'Emergency stock requirement'),
('IND000003', 1, 6, NULL, 'pending', 12000.00, '2024-01-16', '2024-01-22', 'Routine stock indent');

-- Sample pharmacy indent items
INSERT INTO pharmacy_indent_items (indent_id, item_id, requested_quantity, approved_quantity, unit_price, total_price) VALUES
(1, 1, 500, 500, 2.00, 1000.00), (1, 2, 300, 300, 12.50, 3750.00), (1, 3, 400, 400, 6.75, 2700.00),
(2, 13, 200, 200, 2.00, 400.00), (2, 14, 150, 150, 12.50, 1875.00),
(3, 1, 600, 0, 2.00, 1200.00), (3, 4, 100, 0, 320.00, 32000.00);

-- Sample RFQ
INSERT INTO rfq (rfq_number, location_id, title, description, issue_date, submission_deadline, status, created_by) VALUES
('RFQ000001', 1, 'Medical Equipment Purchase', 'Purchase of various medical equipment for hospital', '2024-01-10', '2024-01-20', 'closed', 11),
('RFQ000002', 1, 'Pharmaceutical Supplies', 'Bulk purchase of pharmaceutical items', '2024-01-15', '2024-01-25', 'issued', 11);

-- Sample RFQ items
INSERT INTO rfq_items (rfq_id, item_description, quantity, unit, specifications) VALUES
(1, 'Digital Blood Pressure Monitor', 10, 'Piece', 'Automatic, with memory function'),
(1, 'Pulse Oximeter', 15, 'Piece', 'Finger type, LED display'),
(2, 'Paracetamol 500mg tablets', 10000, 'Tablets', 'WHO GMP certified'),
(2, 'Amoxicillin 250mg capsules', 5000, 'Capsules', 'Blister packed');

-- Sample RFQ responses
INSERT INTO rfq_responses (rfq_id, vendor_id, total_amount, submission_date, validity_days, terms_conditions, status) VALUES
(1, 2, 25000.00, '2024-01-18 14:00:00', 30, 'Payment within 30 days, 1 year warranty', 'accepted'),
(1, 5, 28000.00, '2024-01-19 10:00:00', 45, 'Payment within 45 days, 2 year warranty', 'rejected'),
(2, 3, 180000.00, '2024-01-22 16:00:00', 30, 'Payment within 30 days, quality guarantee', 'submitted');

-- Sample RFQ response items
INSERT INTO rfq_response_items (response_id, rfq_item_id, unit_price, total_price, delivery_days, brand) VALUES
(1, 1, 1500.00, 15000.00, 15, 'Omron'),
(1, 2, 800.00, 12000.00, 10, 'Nellcor'),
(2, 1, 1800.00, 18000.00, 20, 'Philips'),
(2, 2, 900.00, 13500.00, 15, 'Masimo'),
(3, 3, 0.15, 1500.00, 30, 'Generic'),
(3, 4, 0.35, 1750.00, 30, 'Generic');

-- Sample contracts
INSERT INTO contracts (contract_number, location_id, vendor_id, title, description, contract_value, start_date, end_date, status, terms_conditions, created_by) VALUES
('CON000001', 1, 1, 'Annual Medical Supply Contract', 'Annual contract for medical supplies', 500000.00, '2024-01-01', '2024-12-31', 'active', 'Monthly delivery, 30 days payment terms', 11),
('CON000002', 1, 2, 'Equipment Maintenance Contract', 'Annual maintenance contract for medical equipment', 120000.00, '2024-01-01', '2024-12-31', 'active', 'Quarterly maintenance, emergency support', 11);

-- Sample material schemes
INSERT INTO material_schemes (scheme_code, location_id, name, description, scheme_type, value, min_order_value, valid_from, valid_to) VALUES
('SCH001', 1, 'Bulk Purchase Discount', '10% discount on orders above 50000', 'discount', 10.00, 50000.00, '2024-01-01', '2024-12-31'),
('SCH002', 1, 'Free Goods Scheme', 'Buy 10 get 1 free on selected items', 'free_goods', 1.00, 1000.00, '2024-01-01', '2024-06-30'),
('SCH003', 1, 'Early Payment Cashback', '2% cashback for payments within 15 days', 'cashback', 2.00, 10000.00, '2024-01-01', '2024-12-31');

-- Sample AI insights
INSERT INTO ai_insights (location_id, insight_type, title, description, recommendations, confidence_score, generated_at, is_acknowledged, acknowledged_by) VALUES
(1, 'inventory_optimization', 'Low Stock Alert', 'Several items are running low and need reordering', '{"items": ["Surgical Gloves", "Syringes"], "action": "Place order within 3 days"}', 0.95, '2024-01-16 08:00:00', false, NULL),
(1, 'demand_forecast', 'Increased Demand Prediction', 'Paracetamol demand expected to increase by 20% next month', '{"item": "Paracetamol", "increase": "20%", "action": "Increase stock by 500 units"}', 0.87, '2024-01-16 09:00:00', true, 11),
(1, 'cost_analysis', 'Vendor Cost Comparison', 'Vendor B offers 15% better rates for medical supplies', '{"current_vendor": "Vendor A", "recommended_vendor": "Vendor B", "savings": "15%"}', 0.92, '2024-01-16 10:00:00', false, NULL);

-- Sample patient portal access
INSERT INTO patient_portal_access (patient_id, username, password, is_active, last_login) VALUES
(1, 'james.wilson', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', true, '2024-01-16 10:30:00'),
(2, 'maria.garcia', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', true, '2024-01-15 14:20:00'),
(3, 'jennifer.brown', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', true, NULL),
(5, 'sarah.thompson', '$2b$10$rOzJqQjQjQjQjQjQjQjQjO', true, '2024-01-14 16:45:00');

-- Sample patient health records
INSERT INTO patient_health_records (patient_id, record_type, title, description, date_recorded, doctor_id, is_visible_to_patient) VALUES
(1, 'condition', 'Hypertension', 'Diagnosed with essential hypertension', '2023-06-15', 2, true),
(1, 'medication', 'Lisinopril', 'Started on Lisinopril 10mg daily', '2023-06-15', 2, true),
(2, 'condition', 'Type 2 Diabetes', 'Diagnosed with Type 2 Diabetes Mellitus', '2022-03-20', 4, true),
(2, 'medication', 'Metformin', 'Started on Metformin 500mg twice daily', '2022-03-20', 4, true),
(3, 'allergy', 'Shellfish Allergy', 'Severe allergic reaction to shellfish', '2020-08-10', 2, true),
(5, 'condition', 'Migraine', 'Chronic migraine with aura', '2021-11-05', 4, true);

-- Sample patient support tickets
INSERT INTO patient_support_tickets (ticket_number, patient_id, location_id, subject, description, priority, status, assigned_to) VALUES
('TKT000001', 1, 1, 'Appointment Rescheduling', 'Need to reschedule my cardiac follow-up appointment', 'medium', 'resolved', 8),
('TKT000002', 2, 1, 'Lab Report Query', 'Unable to access my latest lab reports online', 'low', 'open', 8),
('TKT000003', 5, 1, 'Billing Inquiry', 'Question about insurance coverage on recent bill', 'high', 'in_progress', 10),
('TKT000004', 3, 1, 'Prescription Refill', 'Need refill for blood pressure medication', 'medium', 'resolved', 6);

-- Sample estimates
INSERT INTO estimates (estimate_number, location_id, patient_id, patient_name, patient_phone, total_amount, discount_amount, net_amount, valid_until, status, created_by) VALUES
('EST000001', 1, NULL, 'John Doe', '9123456700', 5000.00, 500.00, 4500.00, '2024-01-30', 'sent', 8),
('EST000002', 1, 3, 'Jennifer Brown', '9123456786', 8000.00, 800.00, 7200.00, '2024-02-15', 'accepted', 8),
('EST000003', 2, NULL, 'Mike Johnson', '9123456701', 3500.00, 0.00, 3500.00, '2024-01-25', 'draft', 8);

-- Sample estimate items
INSERT INTO estimate_items (estimate_id, item_name, item_code, quantity, unit_price, total_price, category) VALUES
(1, 'Cardiac Screening Package', 'PKG002', 1, 5000.00, 5000.00, 'Package'),
(2, 'Minor Surgery', 'SRV012', 1, 8000.00, 8000.00, 'Surgery'),
(3, 'General Consultation', 'SRV001', 1, 450.00, 450.00, 'Consultation'),
(3, 'X-Ray', 'SRV004', 1, 350.00, 350.00, 'Radiology'),
(3, 'Blood Test', 'SRV005', 1, 230.00, 230.00, 'Laboratory');

-- Sample investigations
INSERT INTO investigations (investigation_number, location_id, patient_id, doctor_id, investigation_type, title, description, status, scheduled_date, completed_date, findings) VALUES
('INV000001', 1, 1, 2, 'radiology', 'Chest X-Ray', 'Chest X-ray for cardiac assessment', 'completed', '2024-01-15 11:00:00', '2024-01-15 11:30:00', 'Mild cardiomegaly noted'),
('INV000002', 1, 2, 4, 'pathology', 'Diabetic Screening', 'Comprehensive diabetic workup', 'completed', '2024-01-15 12:00:00', '2024-01-15 16:00:00', 'HbA1c within target range'),
('INV000003', 1, 5, 4, 'radiology', 'Brain MRI', 'MRI for severe headache evaluation', 'scheduled', '2024-01-18 10:00:00', NULL, NULL);

-- Sample shifts
INSERT INTO shifts (shift_name, location_id, start_time, end_time) VALUES
('Morning Shift', 1, '06:00:00', '14:00:00'),
('Evening Shift', 1, '14:00:00', '22:00:00'),
('Night Shift', 1, '22:00:00', '06:00:00'),
('Day Shift', 2, '08:00:00', '20:00:00'),
('Night Shift', 2, '20:00:00', '08:00:00');

-- Sample user shifts
INSERT INTO user_shifts (user_id, shift_id, shift_date, check_in_time, check_out_time, status, notes) VALUES
(5, 1, '2024-01-15', '2024-01-15 06:00:00', '2024-01-15 14:00:00', 'checked_out', 'Regular shift'),
(5, 2, '2024-01-16', '2024-01-16 14:00:00', '2024-01-16 22:00:00', 'checked_out', 'Regular shift'),
(6, 1, '2024-01-15', '2024-01-15 06:15:00', '2024-01-15 14:10:00', 'checked_out', 'Slightly late'),
(7, 2, '2024-01-16', '2024-01-16 14:00:00', NULL, 'checked_in', 'Current shift');

-- Sample advance collections
INSERT INTO advance_collections (receipt_number, location_id, patient_id, admission_id, amount, payment_method, collected_by, purpose) VALUES
('ADV000001', 1, 1, 1, 10000.00, 'card', 10, 'ICU admission advance'),
('ADV000002', 1, 3, 2, 5000.00, 'cash', 10, 'Treatment advance'),
('ADV000003', 1, 5, 4, 3000.00, 'upi', 10, 'Emergency treatment advance');

-- Sample inpatient census
INSERT INTO inpatient_census (location_id, census_date, total_beds, occupied_beds, available_beds, admissions_today, discharges_today, transfers_in, transfers_out, occupancy_rate) VALUES
(1, '2024-01-15', 14, 8, 6, 2, 1, 0, 0, 57.14),
(1, '2024-01-16', 14, 10, 4, 3, 1, 1, 0, 71.43),
(2, '2024-01-15', 6, 3, 3, 1, 0, 0, 0, 50.00),
(2, '2024-01-16', 6, 2, 4, 0, 1, 0, 0, 33.33);

-- Sample patient transfers
INSERT INTO patient_transfers (transfer_number, patient_id, from_location_id, to_location_id, from_bed_id, to_bed_id, transfer_date, reason, status, transferred_by, received_by) VALUES
('PTR000001', 4, 2, 1, 17, 5, '2024-01-16 15:00:00', 'Specialist consultation required', 'completed', 3, 5);

-- Sample billing accounts
INSERT INTO billing_accounts (account_code, location_id, account_name, account_type, parent_account_id) VALUES
('ACC001', 1, 'Patient Revenue', 'revenue', NULL),
('ACC002', 1, 'Consultation Revenue', 'revenue', 1),
('ACC003', 1, 'Pharmacy Revenue', 'revenue', 1),
('ACC004', 1, 'Lab Revenue', 'revenue', 1),
('ACC005', 1, 'Medical Expenses', 'expense', NULL),
('ACC006', 1, 'Staff Salaries', 'expense', 5),
('ACC007', 1, 'Equipment Expenses', 'expense', 5);

-- Sample price lists
INSERT INTO price_lists (price_list_code, location_id, name, description, effective_from, effective_to, is_default) VALUES
('PL001', 1, 'Standard Price List', 'Standard pricing for all services', '2024-01-01', '2024-12-31', true),
('PL002', 1, 'Insurance Price List', 'Special pricing for insurance patients', '2024-01-01', '2024-12-31', false),
('PL003', 2, 'Branch Standard Pricing', 'Standard pricing for branch location', '2024-01-01', '2024-12-31', true);

-- Sample price list items
INSERT INTO price_list_items (price_list_id, service_id, price) VALUES
(1, 1, 500.00), (1, 2, 800.00), (1, 3, 300.00), (1, 4, 400.00), (1, 5, 250.00),
(2, 1, 400.00), (2, 2, 640.00), (2, 3, 240.00), (2, 4, 320.00), (2, 5, 200.00),
(3, 16, 450.00), (3, 17, 600.00), (3, 18, 280.00), (3, 19, 350.00), (3, 20, 230.00);

-- Sample cashier transactions
INSERT INTO cashier_transactions (transaction_number, location_id, cashier_id, transaction_type, amount, payment_method, reference_number, bill_id, patient_id) VALUES
('TXN000001', 1, 10, 'payment', 1150.00, 'card', 'CARD123456', 1, 1),
('TXN000002', 1, 10, 'payment', 862.50, 'cash', NULL, 2, 2),
('TXN000003', 1, 10, 'advance', 10000.00, 'card', 'CARD789012', NULL, 1),
('TXN000004', 2, 10, 'payment', 859.05, 'insurance', 'INS987654', 4, 4),
('TXN000005', 1, 10, 'refund', 100.00, 'cash', NULL, 1, 1);

-- Sample quick bills
INSERT INTO quick_bills (quick_bill_number, location_id, patient_name, patient_phone, total_amount, paid_amount, payment_method, created_by) VALUES
('QB000001', 1, 'Walk-in Patient 1', '9123456799', 150.00, 150.00, 'cash', 8),
('QB000002', 1, 'Emergency Patient', '9123456798', 500.00, 500.00, 'card', 8),
('QB000003', 2, 'Quick Consultation', '9123456797', 450.00, 450.00, 'upi', 8);

-- Sample quick bill items
INSERT INTO quick_bill_items (quick_bill_id, item_name, quantity, unit_price, total_price) VALUES
(1, 'Dressing', 1, 150.00, 150.00),
(2, 'Emergency Consultation', 1, 500.00, 500.00),
(3, 'General Consultation', 1, 450.00, 450.00);

-- End of sample data