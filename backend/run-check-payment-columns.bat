@echo off
echo Checking payment columns in patient_examination table...
psql -h localhost -U postgres -d hims_db -f check-payment-columns.sql
pause