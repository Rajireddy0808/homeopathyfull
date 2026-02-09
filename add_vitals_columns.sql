USE hims_db;

ALTER TABLE patient_prescriptions 
ADD COLUMN IF NOT EXISTS vitals_respiratory_rate INT NULL,
ADD COLUMN IF NOT EXISTS vitals_weight DECIMAL(5,2) NULL,
ADD COLUMN IF NOT EXISTS vitals_height INT NULL,
ADD COLUMN IF NOT EXISTS vitals_blood_glucose INT NULL,
ADD COLUMN IF NOT EXISTS vitals_pain_scale INT NULL,
ADD COLUMN IF NOT EXISTS nursing_notes TEXT NULL;