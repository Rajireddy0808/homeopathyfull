@echo off
echo Creating patient_examination table...
psql -h localhost -U postgres -d hims_db -f create-patient-examination-table.sql
echo Table creation completed!
pause