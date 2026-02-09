const { Client } = require('pg');

const client = new Client({
  host: 'api.vithyou.com',
  port: 5432,
  username: 'vithyouuser',
  password: 'Veeg@M@123',
  database: 'hims_db',
});

async function checkUsers() {
  try {
    await client.connect();
    const result = await client.query('SELECT id, username, password, role_id FROM users LIMIT 5');
    console.log('Users in database:');
    console.table(result.rows);
  } catch (error) {
    console.error('Error:', error.message);
  } finally {
    await client.end();
  }
}

checkUsers();