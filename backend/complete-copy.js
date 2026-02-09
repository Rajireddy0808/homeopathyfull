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

async function completeCopy() {
  const sourceClient = await sourcePool.connect();
  const targetClient = await targetPool.connect();
  
  try {
    // Get all tables
    const tablesResult = await sourceClient.query(`
      SELECT table_name FROM information_schema.tables 
      WHERE table_schema = 'public' AND table_type = 'BASE TABLE'
      ORDER BY table_name
    `);
    
    const tables = tablesResult.rows.map(row => row.table_name);
    console.log(`Found ${tables.length} tables:`, tables);
    
    // Drop existing tables and recreate
    for (const table of tables) {
      console.log(`\nProcessing table: ${table}`);
      
      try {
        // Drop table if exists
        await targetClient.query(`DROP TABLE IF EXISTS ${table} CASCADE`);
        
        // Get table structure
        const structureResult = await sourceClient.query(`
          SELECT 
            column_name, 
            data_type, 
            character_maximum_length,
            is_nullable, 
            column_default
          FROM information_schema.columns 
          WHERE table_name = $1 AND table_schema = 'public'
          ORDER BY ordinal_position
        `, [table]);
        
        // Create table
        const columns = structureResult.rows.map(col => {
          let colDef = col.column_name;
          
          if (col.data_type === 'character varying') {
            colDef += col.character_maximum_length ? 
              ` VARCHAR(${col.character_maximum_length})` : ' TEXT';
          } else if (col.data_type === 'bigint') {
            colDef += ' BIGINT';
          } else if (col.data_type === 'integer') {
            colDef += ' INTEGER';
          } else if (col.data_type === 'boolean') {
            colDef += ' BOOLEAN';
          } else if (col.data_type === 'timestamp without time zone') {
            colDef += ' TIMESTAMP';
          } else if (col.data_type === 'text') {
            colDef += ' TEXT';
          } else {
            colDef += ` ${col.data_type.toUpperCase()}`;
          }
          
          if (col.is_nullable === 'NO') colDef += ' NOT NULL';
          if (col.column_default && !col.column_default.includes('nextval')) {
            colDef += ` DEFAULT ${col.column_default}`;
          }
          
          return colDef;
        });
        
        // Add primary key if id column exists
        const hasId = structureResult.rows.some(col => col.column_name === 'id');
        if (hasId) {
          const idCol = structureResult.rows.find(col => col.column_name === 'id');
          if (idCol.column_default && idCol.column_default.includes('nextval')) {
            columns[0] = 'id SERIAL PRIMARY KEY';
          }
        }
        
        const createTableQuery = `CREATE TABLE ${table} (${columns.join(', ')})`;
        await targetClient.query(createTableQuery);
        console.log(`✓ Created table structure for ${table}`);
        
        // Copy data
        const dataResult = await sourceClient.query(`SELECT * FROM ${table}`);
        
        if (dataResult.rows.length > 0) {
          const columnNames = Object.keys(dataResult.rows[0]);
          const placeholders = columnNames.map((_, i) => `$${i + 1}`).join(', ');
          
          for (const row of dataResult.rows) {
            const values = columnNames.map(col => row[col]);
            try {
              await targetClient.query(
                `INSERT INTO ${table} (${columnNames.join(', ')}) VALUES (${placeholders})`,
                values
              );
            } catch (insertErr) {
              // Skip duplicate or constraint errors
              if (!insertErr.message.includes('duplicate') && 
                  !insertErr.message.includes('violates')) {
                console.log(`Insert error in ${table}:`, insertErr.message);
              }
            }
          }
          
          console.log(`✓ Copied ${dataResult.rows.length} rows to ${table}`);
        } else {
          console.log(`✓ Table ${table} is empty`);
        }
        
      } catch (err) {
        console.log(`✗ Error with ${table}: ${err.message}`);
      }
    }
    
    console.log('\n✅ Complete copy finished!');
    
  } catch (error) {
    console.error('❌ Error:', error.message);
  } finally {
    sourceClient.release();
    targetClient.release();
    await sourcePool.end();
    await targetPool.end();
  }
}

completeCopy();