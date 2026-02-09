@echo off
echo Running patients table source reference update...
echo.

set PGPASSWORD=your_password
set DB_HOST=localhost
set DB_PORT=5432
set DB_NAME=hims_db
set DB_USER=postgres

echo Updating patients table to reference patient_source by ID...
psql -h %DB_HOST% -p %DB_PORT% -U %DB_USER% -d %DB_NAME% -f "database\update-patients-source-reference.sql"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ✓ Patients table source reference update completed successfully!
) else (
    echo.
    echo ✗ Error occurred during migration. Please check the output above.
)

pause