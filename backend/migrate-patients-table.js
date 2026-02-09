const { Pool } = require('pg');
const fs = require('fs');
const path = require('path');

// Database configuration
const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'hims_db',
  password: 'password',
  port: 5432,
});

async function migratePatientTable() {
  const client = await pool.connect();
  
  try {
    console.log('🚀 Starting patient table migration...');
    
    // Read the SQL file
    const sqlPath = path.join(__dirname, 'database', 'create-patients-table.sql');
    const sql = fs.readFileSync(sqlPath, 'utf8');
    
    // Execute the migration
    await client.query(sql);
    
    console.log('✅ Patient table migration completed successfully!');
    console.log('');
    console.log('📋 Migration Summary:');
    console.log('- Created improved patients table structure');
    console.log('- Added created_by column to track record creators');
    console.log('- Added proper constraints and indexes');
    console.log('- Set up auto-update triggers');
    console.log('- Patient IDs will be auto-generated (P0001, P0002, etc.)');
    
    // Verify the table was created
    const result = await client.query(`
      SELECT column_name, data_type, is_nullable, column_default
      FROM information_schema.columns 
      WHERE table_name = 'patients' 
      ORDER BY ordinal_position
    `);
    
    console.log('');
    console.log('📊 Table Structure:');
    result.rows.forEach(row => {
      console.log(`  ${row.column_name}: ${row.data_type} ${row.is_nullable === 'NO' ? '(NOT NULL)' : ''}`);
    });
    
  } catch (error) {
    console.error('❌ Migration failed:', error.message);
    throw error;
  } finally {
    client.release();
  }
}

// Run the migration
migratePatientTable()
  .then(() => {
    console.log('');
    console.log('🎉 Migration process completed!');
    process.exit(0);
  })
  .catch((error) => {
    console.error('💥 Migration process failed:', error);
    process.exit(1);
  });