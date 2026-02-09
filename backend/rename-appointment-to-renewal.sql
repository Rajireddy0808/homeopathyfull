-- Rename column from next_appointment_date to next_renewal_date
ALTER TABLE patient_examination 
RENAME COLUMN next_appointment_date TO next_renewal_date;