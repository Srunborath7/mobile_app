const db = require('../database/db'); 
const createUsersTable = () => {
  const sql = `
    CREATE TABLE IF NOT EXISTS users (
      id INT AUTO_INCREMENT PRIMARY KEY,
      username VARCHAR(100) NOT NULL,
      email VARCHAR(100) NOT NULL UNIQUE,
      password VARCHAR(255) NOT NULL
    )
  `;
  db.query(sql, (err) => {
    if (err) {
      console.error('Failed to create users table:', err);
    } else {
      console.log('Users table is ready');
    }
  });
};

// 2. Insert user
const insertUser = (user, callback) => {
  const sql = 'INSERT INTO users (username, email, password) VALUES (?, ?, ?)';
  db.query(sql, [user.username, user.email, user.password], callback);
};

const getUser = (email, callback) => {
  const sql = 'SELECT * FROM users WHERE email = ?';
  db.query(sql, [email], callback);
};

module.exports = {
  createUsersTable,
  insertUser,
  getUser
};