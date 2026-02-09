-- Add location_id column to departments table
ALTER TABLE departments ADD COLUMN IF NOT EXISTS location_id INTEGER;

-- Update existing departments with sample location_id values
UPDATE departments SET location_id = 1 WHERE name IN ('Cardiology', 'Neurology', 'Emergency');
UPDATE departments SET location_id = 2 WHERE name IN ('Orthopedics', 'Pediatrics', 'Pharmacy');