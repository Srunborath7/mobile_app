// api/routes/video_article_Route.js
const express = require('express');
const router = express.Router();
const db = require('../database/db'); // adjust if needed

// GET all video articles
router.get('/', (req, res) => {
  db.query('SELECT * FROM video_articles', (err, results) => {
    if (err) {
      console.error('Error fetching video articles:', err);
      return res.status(500).json({ error: 'Database error' });
    }
    res.json(results);
  });
});

// GET video article by ID
router.get('/:id', (req, res) => {
  const id = req.params.id;
  db.query('SELECT * FROM video_articles WHERE id = ?', [id], (err, results) => {
    if (err) {
      console.error(`Error fetching video article with id ${id}:`, err);
      return res.status(500).json({ error: 'Database error' });
    }
    if (results.length === 0) {
      return res.status(404).json({ error: 'Video article not found' });
    }
    res.json(results[0]);
  });
});

// POST create new video article
router.post('/', (req, res) => {
  const { title, description, thumbnail_url, video_url } = req.body;

  if (!title || !video_url) {
    return res.status(400).json({ error: 'Title and video_url are required' });
  }

  const sql = `INSERT INTO video_articles (title, description, thumbnail_url, video_url) VALUES (?, ?, ?, ?)`;
  db.query(sql, [title, description, thumbnail_url, video_url], (err, result) => {
    if (err) {
      console.error('Insert video article error:', err);
      return res.status(500).json({ error: 'Database error' });
    }
    res.status(201).json({ message: 'Video article created', id: result.insertId });
  });
});


// PUT update video article by ID
router.put('/:id', (req, res) => {
  const id = req.params.id;
  const { title, description, video_url } = req.body;
  if (!title || !description || !video_url) {
    return res.status(400).json({ error: 'Please provide title, description and video_url' });
  }

  const updatedArticle = { title, description, video_url };
  db.query('UPDATE video_articles SET ? WHERE id = ?', [updatedArticle, id], (err, result) => {
    if (err) {
      console.error(`Error updating video article with id ${id}:`, err);
      return res.status(500).json({ error: 'Database error' });
    }
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Video article not found' });
    }
    res.json({ message: 'Video article updated' });
  });
});

// DELETE video article by ID
router.delete('/:id', (req, res) => {
  const id = req.params.id;
  db.query('DELETE FROM video_articles WHERE id = ?', [id], (err, result) => {
    if (err) {
      console.error(`Error deleting video article with id ${id}:`, err);
      return res.status(500).json({ error: 'Database error' });
    }
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Video article not found' });
    }
    res.json({ message: 'Video article deleted' });
  });
});

module.exports = router;
