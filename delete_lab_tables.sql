-- Delete Laboratory Masters Tables (PostgreSQL)
-- Run this to remove all laboratory tables from wrong database

-- Drop tables in correct order (child tables first due to foreign keys)
DROP TABLE IF EXISTS lab_test_template_links CASCADE;
DROP TABLE IF EXISTS lab_profile_test_links CASCADE;
DROP TABLE IF EXISTS lab_tests CASCADE;
DROP TABLE IF EXISTS lab_investigations CASCADE;
DROP TABLE IF EXISTS lab_templates CASCADE;
DROP TABLE IF EXISTS lab_methods CASCADE;
DROP TABLE IF EXISTS lab_containers CASCADE;
DROP TABLE IF EXISTS lab_specimens CASCADE;
DROP TABLE IF EXISTS lab_units CASCADE;

-- Drop the trigger function
DROP FUNCTION IF EXISTS update_updated_at_column() CASCADE;