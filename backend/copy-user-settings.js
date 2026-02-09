const { Pool } = require('pg');

const sourcePool = new Pool({
  host: 'api.vithyou.com',
  port: 5432,
  database: 'hims_user_settings',
  user: 'vithyouuser',
  password: 'Veeg@M@123'
});

const targetPool = new Pool({
  host: '127.0.0.1',
  port: 5432,
  database: 'postgres',
  user: 'postgres',
  password: '12345'
});

async function copyUserSettings() {
  const sourceClient = await sourcePool.connect();
  const targetClient = await targetPool.connect();
  
  try {
    console.log('Getting tables from hims_user_settings...');
    const tablesResult = await sourceClient.query(`
      SELECT table_name FROM information_schema.tables 
      WHERE table_schema = 'public' AND table_type = 'BASE TABLE'
      ORDER BY table_name
    `);
    
    const tables = tablesResult.rows.map(row => row.table_name);
    console.log(`Found ${tables.length} tables:`, tables);
    
    for (const table of tables) {
      console.log(`Copying table: ${table}`);
      
      try {
        const dataResult = await sourceClient.query(`SELECT * FROM ${table}`);
        
        if (dataResult.rows.length > 0) {
          const columns = Object.keys(dataResult.rows[0]);
          const placeholders = columns.map((_, i) => `$${i + 1}`).join(', ');
          
          await targetClient.query(`TRUNCATE TABLE ${table} CASCADE`);
          
          for (const row of dataResult.rows) {
            const values = columns.map(col => row[col]);
            await targetClient.query(
              `INSERT INTO ${table} (${columns.join(', ')}) VALUES (${placeholders})`,
              values
            );
          }
          
          console.log(`✓ Copied ${dataResult.rows.length} rows to ${table}`);
        } else {
          console.log(`✓ Table ${table} is empty`);
        }
      } catch (err) {
        console.log(`✗ Error with ${table}: ${err.message}`);
      }
    }
    
    console.log('\n✅ Copy completed successfully!');
    
  } catch (error) {
    console.error('❌ Error:', error.message);
  } finally {
    sourceClient.release();
    targetClient.release();
    await sourcePool.end();
    await targetPool.end();
  }
}

copyUserSettings();