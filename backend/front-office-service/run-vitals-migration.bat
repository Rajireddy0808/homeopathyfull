@echo off
echo Running vitals migration...
psql -h localhost -U postgres -d hims -f migrations/002_add_vitals_columns.sql
echo Migration completed!
pause