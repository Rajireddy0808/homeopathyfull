-- Add amount column to patients table
ALTER TABLE patients ADD COLUMN IF NOT EXISTS amount DECIMAL(10,2);