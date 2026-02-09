const { Pool } = require('pg');

async function migrateTable() {
  const pool = new Pool({
    host: '127.0.0.1',
    port: 5432,
    user: 'postgres',
    password: '12345',
    database: 'postgres',
  });

  try {
    console.log('Starting migration...');
    
    // Rename existing columns
    await pool.query(`
      ALTER TABLE patient_examination 
      RENAME COLUMN treatment_plan_months TO treatment_plan_months_doctor
    `);
    console.log('Renamed treatment_plan_months to treatment_plan_months_doctor');

    await pool.query(`
      ALTER TABLE patient_examination 
      RENAME COLUMN next_renewal_date TO next_renewal_date_doctor
    `);
    console.log('Renamed next_renewal_date to next_renewal_date_doctor');

    // Add new PRO columns
    await pool.query(`
      ALTER TABLE patient_examination 
      ADD COLUMN treatment_plan_months_pro INTEGER
    `);
    console.log('Added treatment_plan_months_pro column');

    await pool.query(`
      ALTER TABLE patient_examination 
      ADD COLUMN next_renewal_date_pro DATE
    `);
    console.log('Added next_renewal_date_pro column');

    console.log('Migration completed successfully!');
  } catch (error) {
    console.error('Migration failed:', error.message);
  } finally {
    await pool.end();
  }
}

migrateTable();