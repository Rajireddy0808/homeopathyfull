-- Telecaller Service Database Schema
-- Database: hims_telecaller

CREATE DATABASE hims_telecaller;
\c hims_telecaller;

-- Locations (replicated for reference)
CREATE TABLE locations (
    id SERIAL PRIMARY KEY,
    location_code VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    address TEXT NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Telecaller campaigns table
CREATE TABLE telecaller_campaigns (
    id SERIAL PRIMARY KEY,
    campaign_name VARCHAR(100) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    description TEXT,
    start_date DATE NOT NULL,
    end_date DATE,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'paused', 'completed', 'cancelled')),
    created_by INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Telecaller follow-ups table
CREATE TABLE telecaller_followups (
    id SERIAL PRIMARY KEY,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    patient_id INTEGER NOT NULL,
    telecaller_id INTEGER NOT NULL,
    campaign_id INTEGER REFERENCES telecaller_campaigns(id),
    follow_up_type VARCHAR(20) NOT NULL CHECK (follow_up_type IN ('appointment_reminder', 'payment_due', 'health_checkup', 'feedback', 'general')),
    scheduled_date TIMESTAMP NOT NULL,
    completed_date TIMESTAMP,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'failed', 'rescheduled')),
    notes TEXT,
    outcome TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Call logs table
CREATE TABLE call_logs (
    id SERIAL PRIMARY KEY,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    telecaller_id INTEGER NOT NULL,
    patient_id INTEGER NOT NULL,
    followup_id INTEGER REFERENCES telecaller_followups(id),
    phone_number VARCHAR(15) NOT NULL,
    call_type VARCHAR(20) NOT NULL CHECK (call_type IN ('outbound', 'inbound')),
    call_status VARCHAR(20) NOT NULL CHECK (call_status IN ('answered', 'no_answer', 'busy', 'invalid_number', 'call_back_requested')),
    call_duration INTEGER, -- in seconds
    call_start_time TIMESTAMP NOT NULL,
    call_end_time TIMESTAMP,
    notes TEXT,
    recording_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Lead management table
CREATE TABLE leads (
    id SERIAL PRIMARY KEY,
    lead_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    email VARCHAR(100),
    source VARCHAR(50) CHECK (source IN ('website', 'referral', 'advertisement', 'walk_in', 'social_media', 'other')),
    lead_type VARCHAR(20) CHECK (lead_type IN ('consultation', 'health_checkup', 'emergency', 'follow_up')),
    status VARCHAR(20) DEFAULT 'new' CHECK (status IN ('new', 'contacted', 'qualified', 'converted', 'lost')),
    assigned_to INTEGER,
    priority VARCHAR(20) DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high', 'urgent')),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(lead_number, location_id)
);

-- Lead activities table
CREATE TABLE lead_activities (
    id SERIAL PRIMARY KEY,
    lead_id INTEGER NOT NULL REFERENCES leads(id) ON DELETE CASCADE,
    activity_type VARCHAR(20) NOT NULL CHECK (activity_type IN ('call', 'email', 'sms', 'meeting', 'note')),
    description TEXT NOT NULL,
    outcome VARCHAR(50),
    next_action VARCHAR(100),
    next_action_date TIMESTAMP,
    performed_by INTEGER NOT NULL,
    performed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- SMS campaigns table
CREATE TABLE sms_campaigns (
    id SERIAL PRIMARY KEY,
    campaign_name VARCHAR(100) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    message_template TEXT NOT NULL,
    target_audience VARCHAR(50) CHECK (target_audience IN ('all_patients', 'appointment_due', 'payment_due', 'health_checkup', 'custom')),
    scheduled_date TIMESTAMP,
    status VARCHAR(20) DEFAULT 'draft' CHECK (status IN ('draft', 'scheduled', 'sent', 'cancelled')),
    total_recipients INTEGER DEFAULT 0,
    sent_count INTEGER DEFAULT 0,
    delivered_count INTEGER DEFAULT 0,
    failed_count INTEGER DEFAULT 0,
    created_by INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- SMS logs table
CREATE TABLE sms_logs (
    id SERIAL PRIMARY KEY,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    campaign_id INTEGER REFERENCES sms_campaigns(id),
    patient_id INTEGER,
    phone_number VARCHAR(15) NOT NULL,
    message_content TEXT NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('sent', 'delivered', 'failed', 'pending')),
    provider_response TEXT,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    delivered_at TIMESTAMP,
    cost DECIMAL(6,4) -- SMS cost
);

-- Appointment reminders table
CREATE TABLE appointment_reminders (
    id SERIAL PRIMARY KEY,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    appointment_id INTEGER NOT NULL,
    patient_id INTEGER NOT NULL,
    reminder_type VARCHAR(20) NOT NULL CHECK (reminder_type IN ('sms', 'call', 'email')),
    reminder_time VARCHAR(20) NOT NULL CHECK (reminder_time IN ('24_hours', '2_hours', '30_minutes')),
    scheduled_at TIMESTAMP NOT NULL,
    sent_at TIMESTAMP,
    status VARCHAR(20) DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'sent', 'failed', 'cancelled')),
    message_content TEXT,
    response_received BOOLEAN DEFAULT false,
    response_content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Customer feedback table
CREATE TABLE customer_feedback (
    id SERIAL PRIMARY KEY,
    feedback_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    patient_id INTEGER NOT NULL,
    service_type VARCHAR(50) NOT NULL,
    rating INTEGER CHECK (rating BETWEEN 1 AND 5),
    feedback_text TEXT,
    suggestions TEXT,
    collected_by INTEGER NOT NULL,
    collection_method VARCHAR(20) CHECK (collection_method IN ('phone', 'email', 'sms', 'in_person', 'online')),
    follow_up_required BOOLEAN DEFAULT false,
    follow_up_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(feedback_number, location_id)
);

-- Telecaller performance metrics table
CREATE TABLE telecaller_performance (
    id SERIAL PRIMARY KEY,
    telecaller_id INTEGER NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    date DATE NOT NULL,
    total_calls INTEGER DEFAULT 0,
    successful_calls INTEGER DEFAULT 0,
    failed_calls INTEGER DEFAULT 0,
    total_call_duration INTEGER DEFAULT 0, -- in seconds
    leads_generated INTEGER DEFAULT 0,
    appointments_scheduled INTEGER DEFAULT 0,
    follow_ups_completed INTEGER DEFAULT 0,
    customer_satisfaction_score DECIMAL(3,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(telecaller_id, location_id, date)
);

-- Indexes
CREATE INDEX idx_telecaller_campaigns_location ON telecaller_campaigns(location_id);
CREATE INDEX idx_telecaller_followups_location ON telecaller_followups(location_id);
CREATE INDEX idx_telecaller_followups_patient ON telecaller_followups(patient_id);
CREATE INDEX idx_telecaller_followups_telecaller ON telecaller_followups(telecaller_id);
CREATE INDEX idx_call_logs_location ON call_logs(location_id);
CREATE INDEX idx_call_logs_telecaller ON call_logs(telecaller_id);
CREATE INDEX idx_call_logs_patient ON call_logs(patient_id);
CREATE INDEX idx_leads_location ON leads(location_id);
CREATE INDEX idx_leads_assigned_to ON leads(assigned_to);
CREATE INDEX idx_lead_activities_lead ON lead_activities(lead_id);
CREATE INDEX idx_sms_campaigns_location ON sms_campaigns(location_id);
CREATE INDEX idx_sms_logs_location ON sms_logs(location_id);
CREATE INDEX idx_sms_logs_campaign ON sms_logs(campaign_id);
CREATE INDEX idx_appointment_reminders_location ON appointment_reminders(location_id);
CREATE INDEX idx_appointment_reminders_appointment ON appointment_reminders(appointment_id);
CREATE INDEX idx_customer_feedback_location ON customer_feedback(location_id);
CREATE INDEX idx_customer_feedback_patient ON customer_feedback(patient_id);
CREATE INDEX idx_telecaller_performance_telecaller ON telecaller_performance(telecaller_id);