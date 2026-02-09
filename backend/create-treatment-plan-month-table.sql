-- Create treatment_plan_month table
CREATE TABLE IF NOT EXISTS treatment_plan_month (
    id SERIAL PRIMARY KEY,
    month VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO treatment_plan_month (month) VALUES 
('1 Month'),
('2 Months'),
('3 Months'),
('6 Months'),
('12 Months')
ON CONFLICT DO NOTHING;

-- Add trigger to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_treatment_plan_month_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_treatment_plan_month_updated_at
    BEFORE UPDATE ON treatment_plan_month
    FOR EACH ROW
    EXECUTE FUNCTION update_treatment_plan_month_updated_at();