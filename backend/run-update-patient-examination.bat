@echo off
echo Updating patient_examination table columns...
mysql -u root -p hims_db < update-patient-examination-columns.sql
echo Patient examination table updated successfully!
pause