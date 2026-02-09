const { Pool } = require('pg');

const pool = new Pool({
  host: '127.0.0.1',
  port: 5432,
  database: 'postgres',
  user: 'postgres',
  password: '12345'
});

async function createPatientTables() {
  const client = await pool.connect();
  
  try {
    await client.query(`
      -- Patients table
      CREATE TABLE IF NOT EXISTS patients (
        id SERIAL PRIMARY KEY,
        patient_id VARCHAR(20) UNIQUE NOT NULL,
        first_name VARCHAR(100) NOT NULL,
        last_name VARCHAR(100) NOT NULL,
        date_of_birth DATE NOT NULL,
        gender VARCHAR(10) NOT NULL,
        phone VARCHAR(15) NOT NULL,
        email VARCHAR(100),
        address TEXT,
        emergency_contact VARCHAR(15),
        blood_group VARCHAR(5),
        allergies TEXT,
        medical_history TEXT,
        location_id INTEGER REFERENCES locations(id),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      -- Consultations table
      CREATE TABLE IF NOT EXISTS consultations (
        id SERIAL PRIMARY KEY,
        consultation_id VARCHAR(20) UNIQUE NOT NULL,
        patient_id INTEGER REFERENCES patients(id) NOT NULL,
        doctor_id INTEGER REFERENCES users(id) NOT NULL,
        consultation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        chief_complaint TEXT,
        history_of_present_illness TEXT,
        examination_findings TEXT,
        diagnosis TEXT,
        treatment_plan TEXT,
        prescription TEXT,
        follow_up_date DATE,
        consultation_fee DECIMAL(10,2),
        location_id INTEGER REFERENCES locations(id),
        status VARCHAR(20) DEFAULT 'completed',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      -- Bills table
      CREATE TABLE IF NOT EXISTS bills (
        id SERIAL PRIMARY KEY,
        bill_id VARCHAR(20) UNIQUE NOT NULL,
        patient_id INTEGER REFERENCES patients(id) NOT NULL,
        consultation_id INTEGER REFERENCES consultations(id),
        total_amount DECIMAL(10,2) NOT NULL,
        discount_amount DECIMAL(10,2) DEFAULT 0,
        tax_amount DECIMAL(10,2) DEFAULT 0,
        net_amount DECIMAL(10,2) NOT NULL,
        payment_method VARCHAR(20),
        payment_status VARCHAR(20) DEFAULT 'pending',
        location_id INTEGER REFERENCES locations(id),
        created_by INTEGER REFERENCES users(id),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      -- Bill items table
      CREATE TABLE IF NOT EXISTS bill_items (
        id SERIAL PRIMARY KEY,
        bill_id INTEGER REFERENCES bills(id) NOT NULL,
        item_name VARCHAR(100) NOT NULL,
        item_type VARCHAR(50),
        quantity INTEGER DEFAULT 1,
        unit_price DECIMAL(10,2) NOT NULL,
        total_price DECIMAL(10,2) NOT NULL
      );

      -- Payment transactions table
      CREATE TABLE IF NOT EXISTS payment_transactions (
        id SERIAL PRIMARY KEY,
        transaction_id VARCHAR(20) UNIQUE NOT NULL,
        bill_id INTEGER REFERENCES bills(id) NOT NULL,
        amount DECIMAL(10,2) NOT NULL,
        payment_method VARCHAR(20) NOT NULL,
        payment_status VARCHAR(20) DEFAULT 'completed',
        reference_number VARCHAR(50),
        transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        created_by INTEGER REFERENCES users(id)
      );
    `);
    
    console.log('✓ Created all patient management tables');
    
  } catch (error) {
    console.error('Error:', error.message);
  } finally {
    client.release();
    await pool.end();
  }
}

createPatientTables();