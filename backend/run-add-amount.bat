@echo off
echo Adding amount column to patients table...

cd /d "%~dp0"

echo Connecting to PostgreSQL and adding amount column...
psql -h localhost -U postgres -d hims_db -f "add-amount-column.sql"

if %ERRORLEVEL% EQU 0 (
    echo Amount column added successfully!
) else (
    echo Failed to add amount column!
    pause
    exit /b 1
)

echo.
echo Amount column added to patients table
echo.
pause