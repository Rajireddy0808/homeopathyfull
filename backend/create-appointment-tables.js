const { Pool } = require('pg');

const pool = new Pool({
  host: '127.0.0.1',
  port: 5432,
  database: 'postgres',
  user: 'postgres',
  password: '12345'
});

async function createAppointmentTables() {
  const client = await pool.connect();
  
  try {
    await client.query(`
      -- Doctors table
      CREATE TABLE IF NOT EXISTS doctors (
        id SERIAL PRIMARY KEY,
        doctor_code VARCHAR(20) UNIQUE NOT NULL,
        name VARCHAR(100) NOT NULL,
        specialization VARCHAR(100),
        location_id INTEGER,
        is_active BOOLEAN DEFAULT TRUE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      -- Appointments table
      CREATE TABLE IF NOT EXISTS appointments (
        id SERIAL PRIMARY KEY,
        appointment_id VARCHAR(20) UNIQUE NOT NULL,
        patient_id INTEGER NOT NULL,
        doctor_id INTEGER NOT NULL,
        appointment_date DATE NOT NULL,
        appointment_time TIME NOT NULL,
        notes TEXT,
        check_for_srdoc_visit BOOLEAN DEFAULT FALSE,
        status VARCHAR(20) DEFAULT 'scheduled',
        location_id INTEGER,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      -- Insert sample doctors
      INSERT INTO doctors (doctor_code, name, specialization, location_id) VALUES 
        ('2116', 'SUJA APPHIA', 'General Medicine', 1),
        ('2117', 'DR. SMITH', 'Cardiology', 1),
        ('2118', 'DR. JONES', 'Orthopedics', 1)
      ON CONFLICT (doctor_code) DO NOTHING;
    `);
    
    console.log('✓ Created appointment tables with sample data');
    
  } catch (error) {
    console.error('Error:', error.message);
  } finally {
    client.release();
    await pool.end();
  }
}

createAppointmentTables();