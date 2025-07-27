const db = require('../database/db');
const bcrypt = require('bcrypt');

// Create role_user table
function createRoleTable() {
  const sql = `
    CREATE TABLE IF NOT EXISTS role_user (
      id INT AUTO_INCREMENT PRIMARY KEY,
      role_title VARCHAR(20) NOT NULL UNIQUE,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
  `;
  db.query(sql, err => {
    if (err) {
      console.error('Failed to create Role table:', err);
    } else {
      console.log('Role table ready');
    }
  });
}

function createUsersTable(callback) {
  const sql = `
    CREATE TABLE IF NOT EXISTS users (
      id INT AUTO_INCREMENT PRIMARY KEY,
      username VARCHAR(50) NOT NULL,
      email VARCHAR(60) NOT NULL UNIQUE,
      password VARCHAR(255) NOT NULL,
      role_id INT DEFAULT 3,
      phone_number VARCHAR(12) NULL,
      full_name VARCHAR(100) NULL,
      address VARCHAR(255) NULL,
      date_of_birth DATE NULL,
      profile VARCHAR(255) NULL,
      bio VARCHAR(255) NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (role_id) REFERENCES role_user(id)
    )
  `;
  db.query(sql, err => {
    if (err) {
      console.error('❌ Failed to create Users table:', err);
    } else {
      console.log('✅ Users table ready');
      if (callback) callback(); // Safe to call insertAdmin
    }
  });
}

// Insert default roles (Admin, Editor, User)
function insertDefaultRoles() {
  const sql = `
    INSERT IGNORE INTO role_user (id, role_title)
    VALUES
      (1, 'Admin'),
      (2, 'Editor'),
      (3, 'User')
  `;
  db.query(sql, err => {
    if (err) {
      console.error('Failed to insert roles:', err);
    } else {
      console.log('Default roles inserted');
    }
  });
}

// Insert default admin user with hashed password
async function insertAdmin() {
  const username = 'admin';
  const email = 'admin@gmail.com';
  const plainPassword = '12345';
  const hashedPassword = await bcrypt.hash(plainPassword, 10);
  const role_id = 1; // Admin

  // Only insert if not exists
  const check = `SELECT * FROM users WHERE email = ?`;
  db.query(check, [email], (err, results) => {
    if (err) return console.error('Error checking admin:', err);
    if (results.length > 0) return console.log('Admin already exists');

    const sql = `INSERT INTO users (username, email, password, role_id) VALUES (?, ?, ?, ?)`;
    db.query(sql, [username, email, hashedPassword, role_id], (err) => {
      if (err) console.error('Failed to insert Admin:', err);
      else console.log('Admin user inserted');
    });
  });
}

// Insert user (used in register or admin create)
function insertUser(user, callback) {
  const sql = `
    INSERT INTO users (username, email, password, role_id)
    VALUES (?, ?, ?, ?)
  `;
  db.query(sql, [user.username, user.email, user.password, user.role_id || 3], callback);
}

// Get user by email (used for login)
function getUser(email, callback) {
  const sql = `
    SELECT users.*, role_user.role_title
    FROM users
    LEFT JOIN role_user ON users.role_id = role_user.id
    WHERE email = ?
  `;
  db.query(sql, [email], (err, results) => {
    callback(err, results[0]);
  });
}

module.exports = {
  createUsersTable,
  createRoleTable,
  insertDefaultRoles,
  insertAdmin,
  insertUser,
  getUser
};
