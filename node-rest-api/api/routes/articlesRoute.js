const express = require('express');
const router = express.Router();
const db = require('../database/db');

router.post('/full', async (req, res) => {
  const { title, summary, category_id, content, image, author } = req.body;

  if (!title || !summary || !category_id || !content || !author || !image) {
    return res.status(400).json({ error: 'Missing fields' });
  }

  const insertArticleSql = `
    INSERT INTO articles (title, summary, image, category_id)
    VALUES (?, ?, ?, ?)
  `;
  db.query(insertArticleSql, [title, summary, image, category_id], (err, result) => {
    if (err) {
      console.error('Insert article error:', err);
      return res.status(500).json({ error: 'Failed to insert article' });
    }

    const articleId = result.insertId;

    const insertDetailSql = `
      INSERT INTO article_detail (article_id, content, author, full_image)
      VALUES (?, ?, ?, ?)
    `;
    db.query(insertDetailSql, [articleId, content, author, image], (err2) => {
      if (err2) {
        console.error('Insert detail error:', err2);
        return res.status(500).json({ error: 'Failed to insert article detail' });
      }

      res.status(201).json({ message: 'Article and detail saved with full image URL' });
    });
  });
});

router.get('/full', (req, res) => {
  const sql = `
    SELECT 
      a.id AS article_id,
      a.title,
      a.summary,
      a.image,
      a.category_id,
      c.name AS category_name,
      d.content,
      d.author,
      d.full_image
    FROM articles a
    LEFT JOIN article_detail d ON a.id = d.article_id
    LEFT JOIN categories c ON a.category_id = c.id
    ORDER BY a.id DESC
  `;

  db.query(sql, (err, results) => {
    if (err) {
      console.error('Error fetching full articles:', err);
      return res.status(500).json({ error: 'Failed to fetch articles' });
    }

    // Just return image URLs as saved (either full URLs or relative paths)
    res.json(results);
  });
});


router.delete('/full/:id', (req, res) => {
  const articleId = req.params.id;

  // Start transaction to ensure both deletes happen together
  db.beginTransaction(err => {
    if (err) return res.status(500).json({ error: err.message });

    // Delete from article_detail first (foreign key depends on articles.id)
    db.query('DELETE FROM article_detail WHERE article_id = ?', [articleId], (err, result) => {
      if (err) {
        return db.rollback(() => {
          res.status(500).json({ error: err.message });
        });
      }

      // Delete from articles
      db.query('DELETE FROM articles WHERE id = ?', [articleId], (err, result) => {
        if (err) {
          return db.rollback(() => {
            res.status(500).json({ error: err.message });
          });
        }

        if (result.affectedRows === 0) {
          return db.rollback(() => {
            res.status(404).json({ error: 'Article not found' });
          });
        }

        // Commit transaction
        db.commit(err => {
          if (err) {
            return db.rollback(() => {
              res.status(500).json({ error: err.message });
            });
          }
          res.json({ message: 'Article and its details deleted successfully' });
        });
      });
    });
  });
});


// Get all article_detail records
router.get('/detail', (req, res) => {
  db.query('SELECT * FROM article_detail', (err, results) => {
    if (err) {
      console.error('Failed to fetch details:', err);
      return res.status(500).json({ error: 'Database error' });
    }
    res.json(results);
  });
});

router.get('/detail/:id', (req, res) => {
  const articleId = req.params.id;
  db.query('SELECT * FROM article_detail WHERE article_id = ?', [articleId], (err, results) => {
    if (err) {
      console.error('Failed to fetch detail:', err);
      return res.status(500).json({ error: 'Database error' });
    }
    if (results.length === 0) {
      return res.status(404).json({ error: 'Detail not found' });
    }
    res.json(results[0]);
  });
});
router.delete('full/:id', (req, res) => {
  const articleId = req.params.id;
  db.query('DELETE FROM articles WHERE id = ?', [articleId], (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    if (result.affectedRows === 0) return res.status(404).json({ error: 'Article not found' });
    res.json({ message: 'Article deleted' });
  });
});
router.put('/full/:id', (req, res) => {
  const articleId = req.params.id;
  const { title, summary, content, image, author } = req.body;

  // Basic validation
  if (!title || !summary || !content || !author || !image) {
    return res.status(400).json({ error: 'Missing fields' });
  }

  const updateArticleSql = `
    UPDATE articles 
    SET title = ?, summary = ?, image = ? 
    WHERE id = ?
  `;

  db.query(updateArticleSql, [title, summary, image, articleId], (err, result) => {
    if (err) {
      console.error('Update article error:', err);
      return res.status(500).json({ error: 'Failed to update article' });
    }

    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Article not found' });
    }

    const updateDetailSql = `
      UPDATE article_detail 
      SET content = ?, author = ? 
      WHERE article_id = ?
    `;

    db.query(updateDetailSql, [content, author, articleId], (err2) => {
      if (err2) {
        console.error('Update article detail error:', err2);
        return res.status(500).json({ error: 'Failed to update article detail' });
      }

      res.json({ message: 'Article and detail updated successfully' });
    });
  });
});

module.exports = router;
