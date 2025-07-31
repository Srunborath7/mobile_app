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
            thumbnail_url: 'https://scontent.fpnh24-1.fna.fbcdn.net/v/t39.30808-6/524342680_1327991388685395_1170425743622767421_n.jpg?_nc_cat=101&ccb=1-7&_nc_sid=833d8c&_nc_eui2=AeEc4T2DOn7jpKEA12sKnHnGKXHkdoB68ZopceR2gHrxmrMhBHjUKQfbMBQihbks7ENE-gXxUcChPjJW7AT9Jo-O&_nc_ohc=xbncfGSh5AEQ7kNvwELv4oe&_nc_oc=AdmeUE7JL_2lFwfkqV2gLSVcyijapddGYZAZCXZQrKKGmNKbu9mAfAimiL6ZPYsZxqA&_nc_zt=23&_nc_ht=scontent.fpnh24-1.fna&_nc_gid=AP8V61Nd0lO6j2taFoABGw&oh=00_AfTKlCvP0kvpc4QXsVLf_7HXi9iNNdag-n8OBe49HUpTMw&oe=6890F6E2',
            video_url: 'https://youtu.be/ES-U1huVBEY?si=dnKBH3lNAAlwMrfs',
          },
          {
            title: 'Cambodia Need Peace ',
            description: 'Thailand and Cambodia agree to immediate ceasefire',
            thumbnail_url: 'https://scontent.fpnh24-1.fna.fbcdn.net/v/t39.30808-6/522912956_807811335443633_118472222620435373_n.jpg?_nc_cat=106&ccb=1-7&_nc_sid=833d8c&_nc_eui2=AeFFH7AYo7keJ8aWTFVKo1_qGBEtVO6OJ5EYES1U7o4nka56TwM5e8__iD_5uEKBhzWOxyFp9iglXW2KKHy3LXFL&_nc_ohc=4CxNVbZtpjAQ7kNvwFEAYig&_nc_oc=AdmqyuMAIBkz7hlOeivS5kc8iHRqSNDJc0fV1oWeMINLhcv-p0A1jeFt3QZoItFZCwk&_nc_zt=23&_nc_ht=scontent.fpnh24-1.fna&_nc_gid=xoTOMGmjH9orPYFOlnZTMQ&oh=00_AfRbNXzjEIPJyxUbi3kNHvDLnbRMP8TauzC1Hnt9u87ilA&oe=68911229',
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
