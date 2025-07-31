const db = require('../database/db');

function createCategoriesTable() {
  const sql = `
    CREATE TABLE IF NOT EXISTS categories (
      id INT AUTO_INCREMENT PRIMARY KEY,
      name VARCHAR(255) NOT NULL UNIQUE
    )
  `;
  return new Promise((resolve, reject) => {
    db.query(sql, (err, result) => {
      if (err) reject(err);
      else resolve(result);
    });
  });
}

function insertDefaultCategories() {
  const sqlCheck = 'SELECT COUNT(*) AS count FROM categories';
  return new Promise((resolve, reject) => {
    db.query(sqlCheck, (err, results) => {
      if (err) return reject(err);

      if (results[0].count > 0) {
        return resolve('Categories already exist, skipping insert');
      }

      const sqlInsert = `
        INSERT INTO categories (name) VALUES 
        ('Technology News'), 
        ('Health News'), 
        ('Finance News'), 
        ('International News'),
        ('Education News'), 
        ('Entertainment News'), 
        ('Political News'),
        ('Sport News')
      `;

      db.query(sqlInsert, (err2, result2) => {
        if (err2) return reject(err2);
        resolve('Default categories inserted');
      });
    });
  });
}

// Correct execution
createCategoriesTable()
  .then(() => {
    console.log('Categories table created successfully');
    return insertDefaultCategories();
  })
  .then((message) => console.log(message))
  .catch((err) => console.error('Error:', err));

module.exports = { createCategoriesTable };
