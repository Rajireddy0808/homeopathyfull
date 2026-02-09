-- Add treatment plan columns to patient_examination table
ALTER TABLE patient_examination 
ADD COLUMN IF NOT EXISTS treatment_plan_months INTEGER,
ADD COLUMN IF NOT EXISTS next_renewal_date DATE;