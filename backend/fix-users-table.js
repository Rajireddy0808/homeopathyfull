const { Pool } = require('pg');

const pool = new Pool({
  host: '127.0.0.1',
  port: 5432,
  database: 'postgres',
  user: 'postgres',
  password: '12345'
});

async function fixUsersTable() {
  const client = await pool.connect();
  
  try {
    await client.query(`
      ALTER TABLE users ADD COLUMN IF NOT EXISTS primary_location_id INTEGER REFERENCES locations(id);
      UPDATE users SET primary_location_id = location_id WHERE primary_location_id IS NULL;
    `);
    
    console.log('Users table fixed successfully');
    
  } catch (error) {
    console.error('Error:', error.message);
  } finally {
    client.release();
    await pool.end();
  }
}

fixUsersTable();