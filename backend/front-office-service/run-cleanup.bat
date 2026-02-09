@echo off
echo Removing patient_prescriptions_new table...
psql -h localhost -U postgres -d hims -f migrations/004_drop_new_table.sql
echo Cleanup completed!
pause