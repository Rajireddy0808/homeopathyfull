-- Add missing vitals columns to patient_prescriptions table

ALTER TABLE patient_prescriptions 
ADD COLUMN IF NOT EXISTS vitals_respiratory_rate INTEGER,
ADD COLUMN IF NOT EXISTS vitals_weight DECIMAL(5,2),
ADD COLUMN IF NOT EXISTS vitals_height INTEGER,
ADD COLUMN IF NOT EXISTS vitals_blood_glucose INTEGER,
ADD COLUMN IF NOT EXISTS vitals_pain_scale INTEGER,
ADD COLUMN IF NOT EXISTS nursing_notes TEXT;

SELECT 'Successfully added vitals columns to patient_prescriptions table' AS result;