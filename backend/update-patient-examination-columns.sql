-- Update patient_examination table columns
-- Rename existing columns and add new ones

ALTER TABLE patient_examination 
RENAME COLUMN treatment_plan_months TO treatment_plan_months_doctor;

ALTER TABLE patient_examination 
RENAME COLUMN next_renewal_date TO next_renewal_date_doctor;

ALTER TABLE patient_examination 
ADD COLUMN treatment_plan_months_pro INT NULL;

ALTER TABLE patient_examination 
ADD COLUMN next_renewal_date_pro DATE NULL;