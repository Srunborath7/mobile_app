// models/trendingArticleModel.js
const db = require('../database/db');

// === Create trending_articles table ===
const createTrendingArticlesTable = () => {
  const query = `
    CREATE TABLE IF NOT EXISTS trending_articles (
      id INT AUTO_INCREMENT PRIMARY KEY,
      title VARCHAR(255) NOT NULL,
      summary TEXT,
      image_url VARCHAR(255),
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
  `;
  db.query(query, (err) => {
    if (err) {
      console.error('❌ Failed to create trending_articles:', err);
    } else {
      console.log('✅ trending_articles table ready');
      insertDefaultTrendingArticles(); // Insert seed data if table is empty
    }
  });
};

// === Create trending_article_details table ===
const createTrendingArticleDetailsTable = () => {
  const query = `
    CREATE TABLE IF NOT EXISTS trending_article_details (
      id INT AUTO_INCREMENT PRIMARY KEY,
      trending_article_id INT NOT NULL,
      full_image_url VARCHAR(255),
      content TEXT,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (trending_article_id) REFERENCES trending_articles(id) ON DELETE CASCADE
    )
  `;
  db.query(query, (err) => {
    if (err) {
      console.error('❌ Failed to create trending_article_details:', err);
    } else {
      console.log('✅ trending_article_details table ready');
      insertDefaultTrendingArticleDetails(); // Insert seed data if table is empty
    }
  });
};

// === Insert default data for trending_articles ===
const insertDefaultTrendingArticles = () => {
  db.query('SELECT COUNT(*) AS count FROM trending_articles', (err, result) => {
    if (err) return console.error(err);
    if (result[0].count === 0) {
      const insertQuery = `
        INSERT INTO trending_articles (title, summary, image_url)
        VALUES 
        ('AI Revolution', 'How AI is changing the world', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTb2-JfHyLYnXx_jk_HXxJgFUx2q3JgNFyhoQ&s'),
        ('Flutter Tips', 'Boost your productivity with Flutter', 'https://assets.goal.com/images/v3/blte395ae2a4ef2d789/Antony.jpg?auto=webp&format=pjpg&width=3840&quality=60'),
        ('SpaceX Launch', 'Next generation of rockets', 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Cat03.jpg/960px-Cat03.jpg')
      `;
      db.query(insertQuery, (err) => {
        if (err) console.error('❌ Failed to insert trending_articles:', err);
        else console.log('✅ Default trending_articles inserted');
      });
    }
  });
};

// === Insert default data for trending_article_details ===
const insertDefaultTrendingArticleDetails = () => {
  db.query('SELECT COUNT(*) AS count FROM trending_article_details', (err, result) => {
    if (err) return console.error(err);
    if (result[0].count === 0) {
      const insertQuery = `
        INSERT INTO trending_article_details (trending_article_id, full_image_url, content)
        VALUES 
        (1, 'https://media.istockphoto.com/id/1347665170/photo/london-at-sunset.jpg?s=612x612&w=0&k=20&c=MdiIzSNKvP8Ct6fdgdV3J4FVcfsfzQjMb6swe2ybY6I=', 'Full content about AI revolution...'),
        (2, 'https://images.pexels.com/photos/460672/pexels-photo-460672.jpeg?cs=srgb&dl=pexels-pixabay-460672.jpg&fm=jpg', 'Deep dive into Flutter productivity...'),
        (3, 'https://media.istockphoto.com/id/1342505734/photo/the-skyline-of-london-city-with-tower-bridge-and-financial-district-during-sunrise.jpg?s=612x612&w=0&k=20&c=HxkAA5zt5DyxkksmRpu6Jo8K3ouHArmIX4jBodNMQuM=', 'All about the latest SpaceX launch...')
      `;
      db.query(insertQuery, (err) => {
        if (err) console.error('❌ Failed to insert trending_article_details:', err);
        else console.log('✅ Default trending_article_details inserted');
      });
    }
  });
};

// === Export functions ===
module.exports = {
  createTrendingArticlesTable,
  createTrendingArticleDetailsTable,
};