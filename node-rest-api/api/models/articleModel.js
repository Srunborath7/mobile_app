const db = require('../database/db');

function createArticlesTable() {
  const sql = `
    CREATE TABLE IF NOT EXISTS articles (
      id INT AUTO_INCREMENT PRIMARY KEY,
      title VARCHAR(255) NOT NULL,
      summary TEXT NOT NULL,
      image VARCHAR(255) NOT NULL,
      category_id INT,
      FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL
    )
  `;
  return new Promise((resolve, reject) => {
    db.query(sql, (err, result) => {
      if (err) reject(err);
      else resolve(result);
    });
  });
}

function createArticleDetailTable() {
  const sql = `
    CREATE TABLE IF NOT EXISTS article_detail (
      id INT AUTO_INCREMENT PRIMARY KEY,
      article_id INT NOT NULL,
      content TEXT NOT NULL,
      author VARCHAR(255) NOT NULL,
      full_image VARCHAR(255) NOT NULL,
      FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE
    )
  `;
  return new Promise((resolve, reject) => {
    db.query(sql, (err, result) => {
      if (err) reject(err);
      else resolve(result);
    });
  });
}

module.exports = {
  createArticlesTable,
  createArticleDetailTable,
};
