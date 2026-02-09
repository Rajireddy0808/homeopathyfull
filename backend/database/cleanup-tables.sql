-- Remove foreign key constraint first
ALTER TABLE users DROP CONSTRAINT IF EXISTS users_role_id_fkey;

-- Remove role_id column from users table
ALTER TABLE users DROP COLUMN IF EXISTS role_id;

-- Remove role-based permission tables in correct order
DROP TABLE IF EXISTS role_menus;
DROP TABLE IF EXISTS role_permissions;
DROP TABLE IF EXISTS menus;
DROP TABLE IF EXISTS permissions;
DROP TABLE IF EXISTS roles;