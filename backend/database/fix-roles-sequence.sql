-- Fix PostgreSQL sequence for roles table
-- Reset sequence to start from 12 since there are already 11 records

SELECT setval('roles_id_seq', 12, false);
ALTER TABLE roles ALTER COLUMN id SET DEFAULT nextval('roles_id_seq');
ALTER SEQUENCE roles_id_seq OWNED BY roles.id;