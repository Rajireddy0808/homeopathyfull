const { Pool } = require('pg');

const pool = new Pool({
  host: '127.0.0.1',
  port: 5432,
  database: 'postgres',
  user: 'postgres',
  password: '12345'
});

async function fixPermissionsTable() {
  const client = await pool.connect();
  
  try {
    await client.query(`
      ALTER TABLE user_location_permissions ADD COLUMN IF NOT EXISTS role_id INTEGER REFERENCES roles(id);
      ALTER TABLE user_location_permissions ADD COLUMN IF NOT EXISTS department_id INTEGER REFERENCES departments(id);
    `);
    
    console.log('Permissions table fixed successfully');
    
  } catch (error) {
    console.error('Error:', error.message);
  } finally {
    client.release();
    await pool.end();
  }
}

fixPermissionsTable();