@echo off
echo Creating new patients table based on UI columns...

cd /d "%~dp0"

echo Connecting to PostgreSQL and creating table...
psql -h localhost -U postgres -d hims_db -f "create-new-patients-table.sql"

if %ERRORLEVEL% EQU 0 (
    echo Table created successfully!
) else (
    echo Failed to create table!
    pause
    exit /b 1
)

echo.
echo New patients table created with:
echo - All UI columns included
echo - Auto-generated: created_by, created_at, updated_at, status
echo - Patient IDs: P0001, P0002, etc.
echo - Default status: 'active'
echo.
pause