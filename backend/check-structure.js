const { Pool } = require('pg');

const sourcePool = new Pool({
  host: 'api.vithyou.com',
  port: 5432,
  database: 'hims_user_settings',
  user: 'vithyouuser',
  password: 'Veeg@M@123'
});

async function checkStructure() {
  const client = await sourcePool.connect();
  
  try {
    const tables = ['users', 'roles', 'modules', 'departments'];
    
    for (const table of tables) {
      console.log(`\n=== ${table.toUpperCase()} ===`);
      
      const columns = await client.query(`
        SELECT column_name, data_type, is_nullable 
        FROM information_schema.columns 
        WHERE table_name = $1 AND table_schema = 'public'
        ORDER BY ordinal_position
      `, [table]);
      
      columns.rows.forEach(col => {
        console.log(`${col.column_name}: ${col.data_type} ${col.is_nullable === 'NO' ? 'NOT NULL' : ''}`);
      });
      
      const sample = await client.query(`SELECT * FROM ${table} LIMIT 3`);
      console.log(`Sample data (${sample.rows.length} rows):`, sample.rows);
    }
    
  } catch (error) {
    console.error('Error:', error.message);
  } finally {
    client.release();
    await sourcePool.end();
  }
}

checkStructure();