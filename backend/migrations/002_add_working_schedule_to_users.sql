-- Add working_days and working_hours columns to users table
ALTER TABLE users 
ADD COLUMN working_days VARCHAR(255) DEFAULT NULL,
ADD COLUMN working_hours VARCHAR(255) DEFAULT NULL;

-- Add comment for documentation
COMMENT ON COLUMN users.working_days IS 'JSON string containing working days configuration';
COMMENT ON COLUMN users.working_hours IS 'JSON string containing working hours configuration';