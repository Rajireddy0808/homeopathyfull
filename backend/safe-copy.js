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

async function safeCopy() {
  const sourceClient = await sourcePool.connect();
  const targetClient = await targetPool.connect();
  
  try {
    // Copy users with valid data
    console.log('Copying users...');
    const users = await sourceClient.query(`
      SELECT id, username, email, password, first_name, last_name, phone, 
             role_id, department_id, location_id, is_active, created_at
      FROM users 
      WHERE email IS NOT NULL AND username IS NOT NULL
    `);
    
    await targetClient.query('TRUNCATE TABLE users CASCADE');
    
    for (const user of users.rows) {
      try {
        await targetClient.query(`
          INSERT INTO users (id, username, email, password, first_name, last_name, phone, 
                           role_id, department_id, location_id, is_active, created_at, primary_location_id)
          VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $10)
        `, [user.id, user.username, user.email, user.password, user.first_name, 
            user.last_name, user.phone, user.role_id, user.department_id, 
            user.location_id, user.is_active, user.created_at]);
      } catch (err) {
        console.log(`Skipping user ${user.username}: ${err.message}`);
      }
    }
    console.log(`✓ Copied ${users.rows.length} users`);
    
    // Copy roles
    console.log('Copying roles...');
    const roles = await sourceClient.query(`
      SELECT id, role_name, description, is_active, created_at
      FROM roles 
      WHERE role_name IS NOT NULL
    `);
    
    await targetClient.query('TRUNCATE TABLE roles CASCADE');
    
    for (const role of roles.rows) {
      try {
        await targetClient.query(`
          INSERT INTO roles (id, role_name, description, is_active, created_at)
          VALUES ($1, $2, $3, $4, $5)
        `, [role.id, role.role_name, role.description, role.is_active, role.created_at]);
      } catch (err) {
        console.log(`Skipping role: ${err.message}`);
      }
    }
    console.log(`✓ Copied ${roles.rows.length} roles`);
    
    // Copy departments
    console.log('Copying departments...');
    const departments = await sourceClient.query(`
      SELECT id, department_code, name, description, location_id, is_active, created_at
      FROM departments 
      WHERE department_code IS NOT NULL AND name IS NOT NULL
    `);
    
    await targetClient.query('TRUNCATE TABLE departments CASCADE');
    
    for (const dept of departments.rows) {
      try {
        await targetClient.query(`
          INSERT INTO departments (id, department_code, name, description, location_id, is_active, created_at)
          VALUES ($1, $2, $3, $4, $5, $6, $7)
        `, [dept.id, dept.department_code, dept.name, dept.description, 
            dept.location_id, dept.is_active, dept.created_at]);
      } catch (err) {
        console.log(`Skipping department: ${err.message}`);
      }
    }
    console.log(`✓ Copied ${departments.rows.length} departments`);
    
    console.log('\n✅ Safe copy completed!');
    
  } catch (error) {
    console.error('❌ Error:', error.message);
  } finally {
    sourceClient.release();
    targetClient.release();
    await sourcePool.end();
    await targetPool.end();
  }
}

safeCopy();