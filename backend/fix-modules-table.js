const { Pool } = require('pg');

const pool = new Pool({
  host: '127.0.0.1',
  port: 5432,
  database: 'postgres',
  user: 'postgres',
  password: '12345'
});

async function fixModulesTable() {
  const client = await pool.connect();
  
  try {
    await client.query(`
      ALTER TABLE modules ADD COLUMN IF NOT EXISTS path VARCHAR(100);
      ALTER TABLE modules ADD COLUMN IF NOT EXISTS name VARCHAR(100);
      ALTER TABLE modules ADD COLUMN IF NOT EXISTS "order" INTEGER DEFAULT 0;
      ALTER TABLE modules ADD COLUMN IF NOT EXISTS status INTEGER DEFAULT 1;
      
      ALTER TABLE sub_modules ADD COLUMN IF NOT EXISTS subcat_name VARCHAR(100);
      ALTER TABLE sub_modules ADD COLUMN IF NOT EXISTS subcat_path VARCHAR(100);
      
      ALTER TABLE user_access ADD COLUMN IF NOT EXISTS role_id INTEGER REFERENCES roles(id);
      ALTER TABLE user_access ADD COLUMN IF NOT EXISTS add BOOLEAN DEFAULT false;
      ALTER TABLE user_access ADD COLUMN IF NOT EXISTS edit BOOLEAN DEFAULT false;
      ALTER TABLE user_access ADD COLUMN IF NOT EXISTS delete BOOLEAN DEFAULT false;
      ALTER TABLE user_access ADD COLUMN IF NOT EXISTS view BOOLEAN DEFAULT false;
      
      UPDATE modules SET path = route, name = module_name, "order" = sort_order WHERE path IS NULL;
      UPDATE sub_modules SET subcat_name = sub_module_name, subcat_path = route WHERE subcat_name IS NULL;
      UPDATE user_access SET add = can_create, edit = can_edit, delete = can_delete, view = can_view WHERE add IS NULL;
    `);
    
    console.log('Modules table fixed successfully');
    
  } catch (error) {
    console.error('Error:', error.message);
  } finally {
    client.release();
    await pool.end();
  }
}

fixModulesTable();