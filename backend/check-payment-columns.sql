-- Check if payment columns exist in patient_examination table
SELECT column_name, data_type, is_nullable, column_default 
FROM information_schema.columns 
WHERE table_name = 'patient_examination' 
AND column_name IN ('total_amount', 'discount_amount', 'paid_amount', 'due_amount');

-- Check current data in patient_examination table
SELECT id, patient_id, total_amount, discount_amount, paid_amount, due_amount 
FROM patient_examination 
WHERE id = 1;