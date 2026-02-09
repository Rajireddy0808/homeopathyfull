@echo off
echo Adding created_by column to patients table...

cd /d "%~dp0"

echo Connecting to PostgreSQL and adding column...
psql -h localhost -U postgres -d hims_db -f "add-created-by-column.sql"

if %ERRORLEVEL% EQU 0 (
    echo Column added successfully!
) else (
    echo Failed to add column!
    pause
    exit /b 1
)

echo.
echo created_by column has been added to track who created each patient record
echo.
pause