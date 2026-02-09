-- Create departments table if not exists
CREATE TABLE IF NOT EXISTS departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    head_of_department VARCHAR(255),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Insert sample departments
INSERT INTO departments (name, description, head_of_department, is_active, created_at, updated_at) 
VALUES 
    ('Cardiology', 'Heart and cardiovascular care', 'Dr. Rajesh Kumar', true, NOW(), NOW()),
    ('Neurology', 'Brain and nervous system care', 'Dr. Priya Patel', true, NOW(), NOW()),
    ('Orthopedics', 'Bone and joint care', 'Dr. Suresh Reddy', true, NOW(), NOW()),
    ('Pediatrics', 'Child healthcare', 'Dr. Anjali Singh', true, NOW(), NOW()),
    ('Emergency', 'Emergency medical care', 'Dr. Vikram Joshi', true, NOW(), NOW()),
    ('Pharmacy', 'Medication management', 'Mr. Amit Sharma', true, NOW(), NOW())
ON CONFLICT (name) DO NOTHING;

-- Add department_id column to users table if not exists
ALTER TABLE users ADD COLUMN IF NOT EXISTS department_id INTEGER REFERENCES departments(id);