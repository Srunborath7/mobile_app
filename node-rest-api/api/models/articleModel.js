const db = require('../database/db');

function createArticlesTable() {
  const sql = `
    CREATE TABLE IF NOT EXISTS articles (
      id INT AUTO_INCREMENT PRIMARY KEY,
      title VARCHAR(255) NOT NULL,
      summary TEXT NOT NULL,
      image_url VARCHAR(255) NOT NULL
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

function insertDefaultArticles() {
  const sqlCheck = 'SELECT COUNT(*) AS count FROM articles';
  return new Promise((resolve, reject) => {
    db.query(sqlCheck, (err, results) => {
      if (err) return reject(err);

      if (results[0].count > 0) {
        return resolve('Articles already exist, skipping insert');
      }

      const sqlInsert = `
        INSERT INTO articles (title, summary, image_url) VALUES 
        ('Sample Article 1', 'This is a summary of article 1', 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6a/Cristiano_Ronaldo_WC2022_-_02.jpg/640px-Cristiano_Ronaldo_WC2022_-_02.jpg'),
        ('Sample Article 2', 'This is a summary of article 2', 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6a/Cristiano_Ronaldo_WC2022_-_02.jpg/640px-Cristiano_Ronaldo_WC2022_-_02.jpg')
      `;

      db.query(sqlInsert, (err2, result2) => {
        if (err2) return reject(err2);
        resolve('Default articles inserted');
      });
    });
  });
}

function insertDefaultArticleDetails() {
  const sqlCheck = 'SELECT COUNT(*) AS count FROM article_detail';
  return new Promise((resolve, reject) => {
    db.query(sqlCheck, (err, results) => {
      if (err) return reject(err);

      if (results[0].count > 0) {
        return resolve('Article details already exist, skipping insert');
      }

      const getArticleIds = `SELECT id, title FROM articles ORDER BY id ASC LIMIT 2`;
      db.query(getArticleIds, (err2, articles) => {
        if (err2) return reject(err2);
        if (articles.length < 2) return reject('Not enough articles found to insert details.');

        const article1 = articles[0];
        const article2 = articles[1];

        const sqlInsert = `
          INSERT INTO article_detail (article_id, content, author, full_image) VALUES
          (?, 'Full content of article 1 goes here...', 'Author One', 'https://st4.depositphotos.com/21607914/23503/i/450/depositphotos_235036072-stock-photo-lionel-messi-argentina-competes-group.jpg'),
          (?, 'Full content of article 2 goes here...', 'Author Two', 'https://i.ebayimg.com/00/s/MTEyOVgxNjAw/z/cbIAAOSwFRxef7xs/$_57.JPG?set_id=8800005007')
        `;

        db.query(sqlInsert, [article1.id, article2.id], (err3, result3) => {
          if (err3) return reject(err3);
          resolve('Default article details inserted');
        });
      });
    });
  });
}

module.exports = {
  createArticlesTable,
  createArticleDetailTable,
  insertDefaultArticles,
  insertDefaultArticleDetails,
};
