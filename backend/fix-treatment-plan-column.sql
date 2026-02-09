-- Add treatment_plan_id column to patient_examination table
ALTER TABLE patient_examination 
ADD COLUMN IF NOT EXISTS treatment_plan_id INTEGER;

-- Create treatment_plan_month table if it doesn't exist
CREATE TABLE IF NOT EXISTS treatment_plan_month (
    id SERIAL PRIMARY KEY,
    month VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data if table is empty
INSERT INTO treatment_plan_month (month) 
SELECT * FROM (VALUES 
    ('1 Month'),
    ('2 Months'),
    ('3 Months'),
    ('6 Months'),
    ('12 Months')
) AS v(month)
WHERE NOT EXISTS (SELECT 1 FROM treatment_plan_month LIMIT 1);