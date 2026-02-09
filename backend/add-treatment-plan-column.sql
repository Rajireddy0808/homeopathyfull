-- Add treatment_plan_id column to patient_examination table
ALTER TABLE patient_examination 
ADD COLUMN IF NOT EXISTS treatment_plan_id INTEGER;