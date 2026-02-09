@echo off
echo Creating fresh patients table...

cd /d "%~dp0"

echo Dropping old table and creating new one...
psql -h localhost -U postgres -d hims_db -f "create-fresh-patients-table.sql"

if %ERRORLEVEL% EQU 0 (
    echo Fresh patients table created successfully!
) else (
    echo Failed to create table!
    pause
    exit /b 1
)

echo.
echo New patients table created with:
echo - All UI columns
echo - Auto-generated system fields
echo - Proper indexes and triggers
echo.
pause