const { Pool } = require('pg');

async function testConnections() {
  console.log('Testing source database connection...');
  
  const sourcePool = new Pool({
    host: 'api.vithyou.com',
    port: 5432,
    database: 'postgres',
    user: 'vithyouuser',
    password: 'Veeg@M@123'
  });
  
  try {
    const client = await sourcePool.connect();
    const result = await client.query('SELECT datname FROM pg_database WHERE datistemplate = false');
    console.log('Available databases:', result.rows.map(r => r.datname));
    client.release();
  } catch (error) {
    console.error('Source connection error:', error.message);
  } finally {
    await sourcePool.end();
  }
}

testConnections();