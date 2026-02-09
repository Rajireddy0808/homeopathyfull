const { Pool } = require('pg');

const pool = new Pool({
  host: '127.0.0.1',
  port: 5432,
  database: 'postgres',
  user: 'postgres',
  password: '12345'
});

async function fixUserAccess() {
  const client = await pool.connect();
  
  try {
    await client.query(`
      ALTER TABLE user_access DROP COLUMN IF EXISTS view;
      ALTER TABLE user_access DROP COLUMN IF EXISTS add;
      ALTER TABLE user_access DROP COLUMN IF EXISTS edit;
      ALTER TABLE user_access DROP COLUMN IF EXISTS delete;
      
      ALTER TABLE user_access ADD COLUMN view INTEGER DEFAULT 0;
      ALTER TABLE user_access ADD COLUMN add INTEGER DEFAULT 0;
      ALTER TABLE user_access ADD COLUMN edit INTEGER DEFAULT 0;
      ALTER TABLE user_access ADD COLUMN delete INTEGER DEFAULT 0;
      
      UPDATE users SET role_id = 1 WHERE username = 'admin';
      
      INSERT INTO user_access (user_id, module_id, role_id, view, add, edit, delete) 
      SELECT 1, id, 1, 1, 1, 1, 1 FROM modules;
    `);
    
    console.log('User access fixed successfully');
    
  } catch (error) {
    console.error('Error:', error.message);
  } finally {
    client.release();
    await pool.end();
  }
}

fixUserAccess();