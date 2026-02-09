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

async function copyDatabase() {
  const sourceClient = await sourcePool.connect();
  const targetClient = await targetPool.connect();
  
  try {
    console.log('Getting table list...');
    const tablesResult = await sourceClient.query(`
      SELECT table_name FROM information_schema.tables 
      WHERE table_schema = 'public' AND table_type = 'BASE TABLE'
      ORDER BY table_name
    `);
    
    const tables = tablesResult.rows.map(row => row.table_name);
    console.log(`Found ${tables.length} tables`);
    
    for (const table of tables) {
      console.log(`Processing table: ${table}`);
      
      try {
        // Copy data
        const dataResult = await sourceClient.query(`SELECT * FROM ${table}`);
        
        if (dataResult.rows.length > 0) {
          const columns = Object.keys(dataResult.rows[0]);
          const placeholders = columns.map((_, i) => `$${i + 1}`).join(', ');
          
          await targetClient.query(`DELETE FROM ${table}`);
          
          for (const row of dataResult.rows) {
            const values = columns.map(col => row[col]);
            await targetClient.query(
              `INSERT INTO ${table} (${columns.join(', ')}) VALUES (${placeholders}) ON CONFLICT DO NOTHING`,
              values
            );
          }
          
          console.log(`Copied ${dataResult.rows.length} rows to ${table}`);
        }
      } catch (err) {
        console.log(`Skipping ${table}: ${err.message}`);
      }
    }
    
    console.log('Database copy completed!');
    
  } catch (error) {
    console.error('Error:', error.message);
  } finally {
    sourceClient.release();
    targetClient.release();
    await sourcePool.end();
    await targetPool.end();
  }
}

copyDatabase();