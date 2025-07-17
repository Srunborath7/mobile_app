const express = require('express');
const router = express.Router();
const db = require('../database/db'); // Adjust path as needed

// GET /articles
router.get('/', (req, res) => {
  db.query('SELECT * FROM articles', (err, results) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: 'Database query error' });
    }
    res.json(results);
  });
});

// POST /api/articles
router.post('/', (req, res) => {
  const { title, summary, image_url } = req.body;

  if (!title || !summary || !image_url) {
    return res.status(400).json({ error: 'Missing required fields' });
  }

  const sql = 'INSERT INTO articles (title, summary, image_url) VALUES (?, ?, ?)';
  const values = [title, summary, image_url];

  db.query(sql, values, (err, result) => {
    if (err) {
      console.error('Insert Error:', err);  // You MUST share this error
      return res.status(500).json({ error: 'Failed to insert article' });
    }

    res.status(201).json({ message: 'Article created', articleId: result.insertId });
  });
});



router.put('/:id', (req, res) => {
  const { id } = req.params;
  const { title, summary, image_url } = req.body;

  const sql = 'UPDATE articles SET title = ?, summary = ?, image_url = ? WHERE id = ?';
  db.query(sql, [title, summary, image_url, id], (err, result) => {
    if (err) {
      console.error('Update Error:', err);
      return res.status(500).json({ error: 'Failed to update article' });
    }
    res.json({ message: 'Article updated successfully' });
  });
});

// DELETE - Delete an article
router.delete('/:id', (req, res) => {
  const { id } = req.params;

  const sql = 'DELETE FROM articles WHERE id = ?';
  db.query(sql, [id], (err, result) => {
    if (err) {
      console.error('Delete Error:', err);
      return res.status(500).json({ error: 'Failed to delete article' });
    }
    res.json({ message: 'Article deleted successfully' });
  });
});

module.exports = router;
