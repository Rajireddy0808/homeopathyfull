@echo off
echo Adding payment columns to patient_examination table...
psql -h localhost -U postgres -d hims_db -f add-payment-columns.sql
echo Payment columns added successfully!
pause