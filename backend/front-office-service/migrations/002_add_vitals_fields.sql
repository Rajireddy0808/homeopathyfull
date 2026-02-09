-- Add additional vitals fields to patient_prescriptions table
ALTER TABLE patient_prescriptions 
ADD COLUMN vitals_respiratory_rate INT NULL,
ADD COLUMN vitals_weight DECIMAL(5,2) NULL,
ADD COLUMN vitals_height INT NULL,
ADD COLUMN vitals_blood_glucose INT NULL,
ADD COLUMN vitals_pain_scale INT NULL,
ADD COLUMN nursing_notes TEXT NULL;