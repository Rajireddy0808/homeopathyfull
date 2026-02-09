@echo off
echo Running Patient Table Migration...

cd /d "%~dp0"

echo Connecting to PostgreSQL and running migration...
psql -h localhost -U postgres -d hims_db -f "database\create-patients-table.sql"

if %ERRORLEVEL% EQU 0 (
    echo Migration completed successfully!
) else (
    echo Migration failed!
    pause
    exit /b 1
)

echo.
echo Patient table has been created with the following features:
echo - Improved structure with organized columns
echo - Added created_by column to track who created each record
echo - Proper constraints and indexes
echo - Auto-generated patient IDs (P0001, P0002, etc.)
echo.
pause