const { Pool } = require('pg');

const pool = new Pool({
  host: '127.0.0.1',
  port: 5432,
  database: 'postgres',
  user: 'postgres',
  password: '12345'
});

async function fixAdminAccess() {
  const client = await pool.connect();
  
  try {
    await client.query(`
      UPDATE users SET role_id = 1, department_id = 1 WHERE username = 'admin';
      
      DELETE FROM user_access WHERE user_id = 1;
      
      INSERT INTO user_access (user_id, module_id, role_id, view, add, edit, delete) 
      SELECT 1, id, 1, 1, 1, 1, 1 FROM modules;
    `);
    
    console.log('Admin access fixed successfully');
    
  } catch (error) {
    console.error('Error:', error.message);
  } finally {
    client.release();
    await pool.end();
  }
}

fixAdminAccess();