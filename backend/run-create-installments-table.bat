@echo off
echo Creating payment_installments table...
psql -h localhost -U postgres -d hims_db -f create-payment-installments-table.sql
echo Payment installments table created successfully!
pause