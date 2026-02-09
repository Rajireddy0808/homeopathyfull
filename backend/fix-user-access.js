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
      ALTER TABLE user_access ALTER COLUMN view TYPE INTEGER USING CASE WHEN view THEN 1 ELSE 0 END;
      ALTER TABLE user_access ALTER COLUMN add TYPE INTEGER USING CASE WHEN add THEN 1 ELSE 0 END;
      ALTER TABLE user_access ALTER COLUMN edit TYPE INTEGER USING CASE WHEN edit THEN 1 ELSE 0 END;
      ALTER TABLE user_access ALTER COLUMN delete TYPE INTEGER USING CASE WHEN delete THEN 1 ELSE 0 END;
      
      UPDATE users SET role_id = 1 WHERE username = 'admin' AND role_id IS NULL;
      
      INSERT INTO user_access (user_id, module_id, role_id, view, add, edit, delete) 
      SELECT 1, id, 1, 1, 1, 1, 1 FROM modules 
      ON CONFLICT DO NOTHING;
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