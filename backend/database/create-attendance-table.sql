-- Create Attendance Table for HIMS User Settings Database
-- This table tracks employee attendance with check-in/check-out times

CREATE TABLE attendance (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    date DATE NOT NULL,
    check_in TIME,
    check_out TIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) DEFAULT 'Present',
    remarks TEXT,
    leave_status VARCHAR(50),
    
    -- Foreign key constraint
    CONSTRAINT fk_attendance_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    
    -- Unique constraint to prevent duplicate entries for same user on same date
    CONSTRAINT unique_user_date UNIQUE (user_id, date)
);

-- Create indexes for better performance
CREATE INDEX idx_attendance_user_id ON attendance(user_id);
CREATE INDEX idx_attendance_date ON attendance(date);
CREATE INDEX idx_attendance_status ON attendance(status);
CREATE INDEX idx_attendance_leave_status ON attendance(leave_status);

-- Add comments for documentation
COMMENT ON TABLE attendance IS 'Employee attendance tracking table';
COMMENT ON COLUMN attendance.id IS 'Primary key for attendance record';
COMMENT ON COLUMN attendance.user_id IS 'Foreign key reference to users table';
COMMENT ON COLUMN attendance.date IS 'Date of attendance';
COMMENT ON COLUMN attendance.check_in IS 'Check-in time';
COMMENT ON COLUMN attendance.check_out IS 'Check-out time';
COMMENT ON COLUMN attendance.status IS 'Attendance status (Present, Absent, Late, etc.)';
COMMENT ON COLUMN attendance.remarks IS 'Additional remarks or notes';
COMMENT ON COLUMN attendance.leave_status IS 'Leave status if applicable (Sick Leave, Casual Leave, etc.)';