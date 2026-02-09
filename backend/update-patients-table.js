const { Pool } = require('pg');

const pool = new Pool({
  host: '127.0.0.1',
  port: 5432,
  database: 'postgres',
  user: 'postgres',
  password: '12345'
});

async function updatePatientsTable() {
  const client = await pool.connect();
  
  try {
    // Add missing columns to patients table
    await client.query(`
      ALTER TABLE patients 
      ADD COLUMN IF NOT EXISTS salutation VARCHAR(10),
      ADD COLUMN IF NOT EXISTS middle_name VARCHAR(100),
      ADD COLUMN IF NOT EXISTS father_spouse_name VARCHAR(100),
      ADD COLUMN IF NOT EXISTS mobile VARCHAR(15),
      ADD COLUMN IF NOT EXISTS marital_status VARCHAR(20),
      ADD COLUMN IF NOT EXISTS address1 TEXT,
      ADD COLUMN IF NOT EXISTS city VARCHAR(100),
      ADD COLUMN IF NOT EXISTS district VARCHAR(100),
      ADD COLUMN IF NOT EXISTS state VARCHAR(100),
      ADD COLUMN IF NOT EXISTS country VARCHAR(100),
      ADD COLUMN IF NOT EXISTS nationality VARCHAR(100),
      ADD COLUMN IF NOT EXISTS pin_code VARCHAR(10),
      ADD COLUMN IF NOT EXISTS mlc_case BOOLEAN DEFAULT FALSE,
      ADD COLUMN IF NOT EXISTS mlc_number VARCHAR(50);
    `);
    
    console.log('✓ Updated patients table with new columns');
    
  } catch (error) {
    console.error('Error:', error.message);
  } finally {
    client.release();
    await pool.end();
  }
}

updatePatientsTable();