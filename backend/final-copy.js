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

async function finalCopy() {
  const sourceClient = await sourcePool.connect();
  const targetClient = await targetPool.connect();
  
  try {
    // Copy users
    console.log('Copying users...');
    const users = await sourceClient.query(`
      SELECT id, username, COALESCE(email, username || '@hospital.com') as email, 
             password, first_name, last_name, phone, primary_location_id, 
             is_active, created_at, employee_id
      FROM users 
      WHERE username IS NOT NULL
    `);
    
    await targetClient.query('TRUNCATE TABLE users CASCADE');
    
    for (const user of users.rows) {
      try {
        await targetClient.query(`
          INSERT INTO users (id, username, email, password, first_name, last_name, 
                           phone, location_id, primary_location_id, is_active, created_at)
          VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $8, $9, $10)
        `, [user.id, user.username, user.email, user.password, user.first_name, 
            user.last_name, user.phone, user.primary_location_id, user.is_active, user.created_at]);
      } catch (err) {
        console.log(`Skipping user ${user.username}: ${err.message}`);
      }
    }
    console.log(`✓ Copied ${users.rows.length} users`);
    
    // Copy roles  
    console.log('Copying roles...');
    const roles = await sourceClient.query(`
      SELECT id, name as role_name, is_active::boolean, created_at
      FROM roles 
      WHERE name IS NOT NULL
    `);
    
    await targetClient.query('TRUNCATE TABLE roles CASCADE');
    
    for (const role of roles.rows) {
      try {
        await targetClient.query(`
          INSERT INTO roles (id, role_name, is_active, created_at)
          VALUES ($1, $2, $3, $4)
        `, [role.id, role.role_name, role.is_active, role.created_at]);
      } catch (err) {
        console.log(`Skipping role: ${err.message}`);
      }
    }
    console.log(`✓ Copied ${roles.rows.length} roles`);
    
    // Copy modules
    console.log('Copying modules...');
    const modules = await sourceClient.query(`
      SELECT id, name as module_name, path as route, icon, "order" as sort_order, 
             status as is_active, created_at
      FROM modules 
      WHERE name IS NOT NULL
    `);
    
    await targetClient.query('TRUNCATE TABLE modules CASCADE');
    
    for (const module of modules.rows) {
      try {
        await targetClient.query(`
          INSERT INTO modules (id, module_name, route, icon, sort_order, is_active, created_at, 
                             path, name, "order", status)
          VALUES ($1, $2, $3, $4, $5, $6::boolean, $7, $3, $2, $5, $6)
        `, [module.id, module.module_name, module.route, module.icon, 
            module.sort_order, module.is_active === 1, module.created_at]);
      } catch (err) {
        console.log(`Skipping module: ${err.message}`);
      }
    }
    console.log(`✓ Copied ${modules.rows.length} modules`);
    
    // Copy departments
    console.log('Copying departments...');
    const departments = await sourceClient.query(`
      SELECT id, name, description, location_id, is_active, created_at,
             'DEPT' || LPAD(id::text, 3, '0') as department_code
      FROM departments 
      WHERE name IS NOT NULL
    `);
    
    await targetClient.query('TRUNCATE TABLE departments CASCADE');
    
    for (const dept of departments.rows) {
      try {
        await targetClient.query(`
          INSERT INTO departments (id, department_code, name, description, 
                                 location_id, is_active, created_at)
          VALUES ($1, $2, $3, $4, $5, $6, $7)
        `, [dept.id, dept.department_code, dept.name, dept.description, 
            dept.location_id, dept.is_active, dept.created_at]);
      } catch (err) {
        console.log(`Skipping department: ${err.message}`);
      }
    }
    console.log(`✓ Copied ${departments.rows.length} departments`);
    
    console.log('\n✅ Final copy completed successfully!');
    
  } catch (error) {
    console.error('❌ Error:', error.message);
  } finally {
    sourceClient.release();
    targetClient.release();
    await sourcePool.end();
    await targetPool.end();
  }
}

finalCopy();