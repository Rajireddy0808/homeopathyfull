@echo off
echo Creating treatment_plan_month table...
psql -h localhost -U postgres -d hims_db -f create-treatment-plan-month-table.sql
echo Adding treatment_plan_id column to patient_examination table...
psql -h localhost -U postgres -d hims_db -f add-treatment-plan-column.sql
echo Setup completed!
pause