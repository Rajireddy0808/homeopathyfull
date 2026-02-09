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

async function fixModules() {
  const sourceClient = await sourcePool.connect();
  const targetClient = await targetPool.connect();
  
  try {
    await targetClient.query('DROP TABLE IF EXISTS modules CASCADE');
    
    await targetClient.query(`
      CREATE TABLE modules (
        id BIGINT PRIMARY KEY,
        path VARCHAR(255),
        name VARCHAR(255),
        icon VARCHAR(255),
        "order" BIGINT,
        status INTEGER,
        created_at TIMESTAMP
      )
    `);
    
    const modules = await sourceClient.query('SELECT * FROM modules');
    
    for (const module of modules.rows) {
      await targetClient.query(`
        INSERT INTO modules (id, path, name, icon, "order", status, created_at)
        VALUES ($1, $2, $3, $4, $5, $6, $7)
      `, [module.id, module.path, module.name, module.icon, 
          module.order, module.status, module.created_at]);
    }
    
    console.log(`✓ Fixed modules table with ${modules.rows.length} rows`);
    
  } catch (error) {
    console.error('Error:', error.message);
  } finally {
    sourceClient.release();
    targetClient.release();
    await sourcePool.end();
    await targetPool.end();
  }
}

fixModules();