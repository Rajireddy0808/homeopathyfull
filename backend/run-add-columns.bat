@echo off
echo Adding missing columns to existing patients table...

cd /d "%~dp0"

echo Connecting to PostgreSQL and adding columns...
psql -h localhost -U postgres -d hims_db -f "add-missing-patient-columns.sql"

if %ERRORLEVEL% EQU 0 (
    echo Columns added successfully!
) else (
    echo Failed to add columns!
    pause
    exit /b 1
)

echo.
echo Added columns: medical_conditions, fee, fee_type, occupation, specialization, doctor, status
echo Updated trigger for updated_at timestamp
echo.
pause