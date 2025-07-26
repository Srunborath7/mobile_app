const express = require('express');
const router = express.Router();
const db = require('../database/db');

// =============================
// 1. GET all articles (for homepage)
// =============================
router.get('/', (req, res) => {
  db.query('SELECT * FROM articles', (err, results) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: 'Database query error' });
    }
    res.json(results);
  });
});

// GET article by ID
router.get('/:id', (req, res) => {
  const articleId = req.params.id;
  db.query('SELECT * FROM articles WHERE id = ?', [articleId], (err, results) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: 'Database query error' });
    }
    if (results.length === 0) {
      return res.status(404).json({ error: 'Article not found' });
    }
    res.json(results[0]);
  });
});


// =============================
// 2. GET article detail by ID (for detail page)
// =============================
router.get('/detail/:id', (req, res) => {
  const articleId = req.params.id;

  db.query('SELECT * FROM article_detail WHERE article_id = ?', [articleId], (err, results) => {
    if (err) {
      console.error('Detail Query Error:', err);
      return res.status(500).json({ error: 'Failed to fetch article detail' });
    }

    if (results.length === 0) {
      return res.status(404).json({ error: 'Article detail not found' });
    }

    res.json(results[0]);
  });
});

// =============================
// 3. POST basic article only (already exists in your code)
// =============================
router.post('/', (req, res) => {
  const { title, summary, image_url } = req.body;

  if (!title || !summary || !image_url) {
    return res.status(400).json({ error: 'Missing required fields' });
  }

  const sql = 'INSERT INTO articles (title, summary, image_url) VALUES (?, ?, ?)';
  const values = [title, summary, image_url];

  db.query(sql, values, (err, result) => {
    if (err) {
      console.error('Insert Error:', err);
      return res.status(500).json({ error: 'Failed to insert article' });
    }

    res.status(201).json({ message: 'Article created', articleId: result.insertId });
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


// =============================
// POST only into article_detail (not articles)
router.post('/detail', (req, res) => {
  const { article_id, content, author, full_image } = req.body;

  if (!article_id || !content || !author || !full_image) {
    return res.status(400).json({ error: 'Missing required fields' });
  }

  const sql = 'INSERT INTO article_detail (article_id, content, author, full_image) VALUES (?, ?, ?, ?)';
  const values = [article_id, content, author, full_image];

  db.query(sql, values, (err, result) => {
    if (err) {
      console.error('Insert article_detail Error:', err);
      return res.status(500).json({ error: 'Failed to insert into article_detail' });
    }

    res.status(201).json({ message: 'Article detail inserted successfully', detailId: result.insertId });
  });
});

// Update article_detail by id
router.put('/detail/:id', (req, res) => {
  const { id } = req.params;
  const { article_id, content, author, full_image } = req.body;

  if (!article_id || !content || !author || !full_image) {
    return res.status(400).json({ error: 'Missing required fields' });
  }

  const sql = `
    UPDATE article_detail 
    SET article_id = ?, content = ?, author = ?, full_image = ? 
    WHERE id = ?
  `;

  const values = [article_id, content, author, full_image, id];

  db.query(sql, values, (err, result) => {
    if (err) {
      console.error('Update article_detail Error:', err);
      return res.status(500).json({ error: 'Failed to update article_detail' });
    }

    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Article detail not found' });
    }

    res.json({ message: 'Article detail updated successfully' });
  });
});



// =============================
// 5. PUT - Update basic article
// =============================
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

// =============================
// 6. DELETE - Delete article
// =============================
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
