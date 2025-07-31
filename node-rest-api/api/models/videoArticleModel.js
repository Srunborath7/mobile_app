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
            title: 'Thailand Fired Cambodia First',
            description: 'Thailand launches airstrikes on Cambodian military targets as deadly border dispute escalates',
            thumbnail_url: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRUXFrYIb8ELf2TSsoGUXH4fygzgghWH5dR6Q&s',
            video_url: 'https://youtu.be/el3NXxiswQY?si=SzyLPdVSV0I_1O9v',
          },
          {
            title: 'Thailand started the war',
            description: 'Thailand launches airstrikes on Cambodia after clashes on disputed border | BBC News',
            thumbnail_url: 'https://i.ytimg.com/vi/e4UgsIGVJAk/mqdefault.jpg',
            video_url: 'https://youtu.be/ES-U1huVBEY?si=dnKBH3lNAAlwMrfs',
          },
          {
            title: 'Cambodia Need Peace ',
            description: 'Thailand and Cambodia agree to immediate ceasefire',
            thumbnail_url: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRu3JUA2cWCOfkadTkDLVrCrIrxSjtZdvqrZQ&s',
            video_url: 'https://youtu.be/iqoDoq9wHds?si=5NpkCdT66_Hpq3I4',
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
