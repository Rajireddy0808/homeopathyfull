-- Create payment_installments table for tracking multiple payments
CREATE TABLE payment_installments (
    id SERIAL PRIMARY KEY,
    patient_examination_id INTEGER NOT NULL,
    installment_number INTEGER NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_examination_id) REFERENCES patient_examination(id) ON DELETE CASCADE
);

-- Create trigger for updated_at column
CREATE OR REPLACE FUNCTION update_installments_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_payment_installments_updated_at
    BEFORE UPDATE ON payment_installments
    FOR EACH ROW
    EXECUTE FUNCTION update_installments_updated_at_column();

-- Create index for better performance
CREATE INDEX idx_payment_installments_examination_id ON payment_installments(patient_examination_id);
CREATE INDEX idx_payment_installments_date ON payment_installments(payment_date);