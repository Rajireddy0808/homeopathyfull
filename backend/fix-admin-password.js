const { Pool } = require('pg');
const bcrypt = require('bcryptjs');

const pool = new Pool({
  host: '127.0.0.1',
  port: 5432,
  database: 'postgres',
  user: 'postgres',
  password: '12345'
});

async function fixAdminPassword() {
  const client = await pool.connect();
  
  try {
    const hashedPassword = await bcrypt.hash('admin', 10);
    
    await client.query(`
      UPDATE users SET password = $1 WHERE username = 'admin';
    `, [hashedPassword]);
    
    console.log('Admin password updated successfully');
    
  } catch (error) {
    console.error('Error:', error.message);
  } finally {
    client.release();
    await pool.end();
  }
}

fixAdminPassword();