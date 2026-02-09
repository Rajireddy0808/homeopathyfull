-- Sample appointments data for testing
-- Make sure to run this after the appointments schema is created

-- Insert sample locations if not exists
INSERT INTO locations (location_code, name, address, phone, email) VALUES 
('LOC001', 'Main Hospital', '123 Hospital Street, City', '+91-1234567890', 'main@hospital.com')
ON CONFLICT (location_code) DO NOTHING;

-- Insert sample appointments
INSERT INTO appointments (
    appointment_number, 
    location_id, 
    patient_id, 
    doctor_id, 
    appointment_date, 
    type, 
    status, 
    reason, 
    notes, 
    consultation_fee
) VALUES 
(
    'APT001', 
    1, 
    1001, 
    201, 
    '2024-01-20 10:00:00', 
    'consultation', 
    'confirmed', 
    'Regular checkup', 
    'Patient requested morning slot', 
    800.00
),
(
    'APT002', 
    1, 
    1002, 
    202, 
    '2024-01-20 11:30:00', 
    'follow_up', 
    'scheduled', 
    'Follow-up visit', 
    'Previous treatment review', 
    500.00
),
(
    'APT003', 
    1, 
    1003, 
    203, 
    '2024-01-20 14:00:00', 
    'consultation', 
    'completed', 
    'New patient consultation', 
    'First visit completed successfully', 
    600.00
),
(
    'APT004', 
    1, 
    1004, 
    201, 
    '2024-01-21 09:00:00', 
    'emergency', 
    'in_progress', 
    'Emergency consultation', 
    'Urgent case', 
    1000.00
),
(
    'APT005', 
    1, 
    1005, 
    204, 
    '2024-01-21 15:30:00', 
    'routine_checkup', 
    'scheduled', 
    'Annual health checkup', 
    'Routine examination', 
    400.00
);