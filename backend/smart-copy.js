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

async function smartCopy() {
  const sourceClient = await sourcePool.connect();
  const targetClient = await targetPool.connect();
  
  try {
    const tables = ['users', 'roles', 'modules', 'sub_modules', 'departments', 'user_access'];
    
    for (const table of tables) {
      console.log(`Processing ${table}...`);
      
      try {
        // Get source columns
        const sourceColumns = await sourceClient.query(`
          SELECT column_name FROM information_schema.columns 
          WHERE table_name = $1 AND table_schema = 'public'
        `, [table]);
        
        // Get target columns  
        const targetColumns = await targetClient.query(`
          SELECT column_name FROM information_schema.columns 
          WHERE table_name = $1 AND table_schema = 'public'
        `, [table]);
        
        const sourceCols = sourceColumns.rows.map(r => r.column_name);
        const targetCols = targetColumns.rows.map(r => r.column_name);
        const commonCols = sourceCols.filter(col => targetCols.includes(col));
        
        if (commonCols.length > 0) {
          const data = await sourceClient.query(`SELECT ${commonCols.join(', ')} FROM ${table}`);
          
          if (data.rows.length > 0) {
            await targetClient.query(`TRUNCATE TABLE ${table} CASCADE`);
            
            const placeholders = commonCols.map((_, i) => `$${i + 1}`).join(', ');
            
            for (const row of data.rows) {
              const values = commonCols.map(col => row[col]);
              await targetClient.query(
                `INSERT INTO ${table} (${commonCols.join(', ')}) VALUES (${placeholders})`,
                values
              );
            }
            
            console.log(`✓ Copied ${data.rows.length} rows to ${table}`);
          }
        }
      } catch (err) {
        console.log(`✗ Error with ${table}: ${err.message}`);
      }
    }
    
    console.log('\n✅ Smart copy completed!');
    
  } catch (error) {
    console.error('❌ Error:', error.message);
  } finally {
    sourceClient.release();
    targetClient.release();
    await sourcePool.end();
    await targetPool.end();
  }
}

smartCopy();