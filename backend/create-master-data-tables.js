const { Pool } = require('pg');

const pool = new Pool({
  host: '127.0.0.1',
  port: 5432,
  database: 'postgres',
  user: 'postgres',
  password: '12345'
});

async function createMasterDataTables() {
  const client = await pool.connect();
  
  try {
    await client.query(`
      -- Gender table
      CREATE TABLE IF NOT EXISTS gender (
        id SERIAL PRIMARY KEY,
        code VARCHAR(10) UNIQUE NOT NULL,
        name VARCHAR(50) NOT NULL,
        description TEXT,
        is_active BOOLEAN DEFAULT TRUE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      -- Blood Group table
      CREATE TABLE IF NOT EXISTS blood_group (
        id SERIAL PRIMARY KEY,
        code VARCHAR(10) UNIQUE NOT NULL,
        name VARCHAR(20) NOT NULL,
        description TEXT,
        is_active BOOLEAN DEFAULT TRUE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      -- Marital Status table
      CREATE TABLE IF NOT EXISTS marital_status (
        id SERIAL PRIMARY KEY,
        code VARCHAR(20) UNIQUE NOT NULL,
        name VARCHAR(50) NOT NULL,
        description TEXT,
        is_active BOOLEAN DEFAULT TRUE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      -- Insert sample data for Gender
      INSERT INTO gender (code, name) VALUES 
        ('M', 'Male'),
        ('F', 'Female'),
        ('O', 'Other')
      ON CONFLICT (code) DO NOTHING;

      -- Insert sample data for Blood Group
      INSERT INTO blood_group (code, name) VALUES 
        ('A+', 'A Positive'),
        ('A-', 'A Negative'),
        ('B+', 'B Positive'),
        ('B-', 'B Negative'),
        ('AB+', 'AB Positive'),
        ('AB-', 'AB Negative'),
        ('O+', 'O Positive'),
        ('O-', 'O Negative')
      ON CONFLICT (code) DO NOTHING;

      -- Insert sample data for Marital Status
      INSERT INTO marital_status (code, name) VALUES 
        ('SINGLE', 'Single'),
        ('MARRIED', 'Married'),
        ('DIVORCED', 'Divorced'),
        ('WIDOWED', 'Widowed')
      ON CONFLICT (code) DO NOTHING;
    `);
    
    console.log('✓ Created master data tables with sample data');
    
  } catch (error) {
    console.error('Error:', error.message);
  } finally {
    client.release();
    await pool.end();
  }
}

createMasterDataTables();