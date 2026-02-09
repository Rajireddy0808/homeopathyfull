-- Add payment columns to patient_examination table
ALTER TABLE patient_examination 
ADD COLUMN total_amount DECIMAL(10,2) DEFAULT 0,
ADD COLUMN discount_amount DECIMAL(10,2) DEFAULT 0,
ADD COLUMN paid_amount DECIMAL(10,2) DEFAULT 0,
ADD COLUMN due_amount DECIMAL(10,2) DEFAULT 0;

-- Create patient_payments table for multiple payment methods
CREATE TABLE patient_payments (
    id SERIAL PRIMARY KEY,
    patient_examination_id INTEGER NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_examination_id) REFERENCES patient_examination(id) ON DELETE CASCADE
);

-- Create trigger for updated_at column
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_patient_payments_updated_at
    BEFORE UPDATE ON patient_payments
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();