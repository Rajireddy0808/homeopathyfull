-- Create user_info table
CREATE TABLE user_info (
    id SERIAL PRIMARY KEY,
    user_type VARCHAR(10) DEFAULT 'staff' CHECK (user_type IN ('doctor', 'staff')),
    alternate_phone VARCHAR(20),
    address TEXT,
    pincode VARCHAR(10),
    qualification VARCHAR(255),
    years_of_experience INTEGER,
    medical_registration_number VARCHAR(100),
    registration_council VARCHAR(100),
    registration_valid_until DATE,
    license_copy VARCHAR(255),
    degree_certificates TEXT,
    employment_type VARCHAR(50),
    joining_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Add user_info_id column to users table
ALTER TABLE users ADD COLUMN user_info_id INTEGER;
ALTER TABLE users ADD CONSTRAINT fk_user_info FOREIGN KEY (user_info_id) REFERENCES user_info(id);