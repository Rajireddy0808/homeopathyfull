@echo off
echo Running database migrations...

set PGPASSWORD=Veeg@M@123
psql -h api.vithyou.com -p 5432 -U vithyouuser -d hims_patient_management -f run_migrations.sql

if %ERRORLEVEL% EQU 0 (
    echo Migrations completed successfully!
) else (
    echo Migration failed with error code %ERRORLEVEL%
)

pause