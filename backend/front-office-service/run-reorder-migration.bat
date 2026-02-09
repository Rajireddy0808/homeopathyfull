@echo off
echo Reordering patient_prescriptions columns...
psql -h localhost -U postgres -d hims -f migrations/003_reorder_columns.sql
echo Column reordering completed!
pause