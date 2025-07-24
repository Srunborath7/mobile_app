const db = require('../database/db');

async function createVideoArticlesTable() {
  const sql = `
    CREATE TABLE IF NOT EXISTS video_articles (
      id INT AUTO_INCREMENT PRIMARY KEY,
      title VARCHAR(255) NOT NULL,
      description TEXT,
      thumbnail_url VARCHAR(255),
      video_url VARCHAR(255),
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
  `;
  return new Promise((resolve, reject) => {
    db.query(sql, (err) => {
      if (err) reject(err);
      else {
        console.log('✅ video_articles table is ready');
        resolve();
      }
    });
  });
}

async function insertDefaultVideoArticles() {
  return new Promise((resolve, reject) => {
    db.query('SELECT COUNT(*) AS count FROM video_articles', (err, results) => {
      if (err) return reject(err);

      if (results[0].count === 0) {
        const defaultVideos = [
          {
            title: 'Flutter Video Tutorial',
            description: 'Learn Flutter step-by-step with this tutorial.',
            thumbnail_url: 'https://img.freepik.com/free-vector/sad-boy-with-sweat-drops_1308-170838.jpg',
            video_url: 'https://youtu.be/pBTPyCAyggE?si=Ik4-mj1RcXgYVxje',
          },
          {
            title: 'kab tic tic klach oun chue',
            description: 'Understand the basics of Dart language.',
            thumbnail_url: 'https://cdn.vectorstock.com/i/1000v/01/39/sad-boy-sitting-on-the-ground-floor-vector-47590139.jpg',
            video_url: 'https://youtu.be/3j8qPENMeHU?si=ZyDcJgzkB7KynSb2',
          },
          {
            title: 'sad men ',
            description: 'Bloc vs Provider in Flutter.',
            thumbnail_url: 'https://cdn.vectorstock.com/i/1000v/25/34/sad-boy-sitting-on-floor-vector-26542534.jpg',
            video_url: 'https://youtu.be/D1NWT9ZeV2A?si=dhPqcjASQnqJg9xI',
          },
        ];

        // Insert all default videos sequentially
        let completed = 0;
        defaultVideos.forEach(video => {
          db.query(
            `INSERT INTO video_articles (title, description, thumbnail_url, video_url) VALUES (?, ?, ?, ?)`,
            [video.title, video.description, video.thumbnail_url, video.video_url],
            (err) => {
              if (err) return reject(err);

              console.log(`Inserted video article: ${video.title}`);
              completed++;
              if (completed === defaultVideos.length) resolve();
            }
          );
        });
      } else {
        console.log(`Video articles already exist (${results[0].count}). Skipping insert.`);
        resolve();
      }
    });
  });
}

module.exports = {
  createVideoArticlesTable,
  insertDefaultVideoArticles,
};
