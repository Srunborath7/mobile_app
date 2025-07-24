const express = require('express');
const router = express.Router();
const db = require('../database/db'); // your db connection

// GET trending articles
router.get('/', (req, res) => {
  const sql = 'SELECT * FROM trending_articles ORDER BY created_at DESC'; // adjust your table & columns
  db.query(sql, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

///get by ID
router.get('/:id', (req, res) => {
  const articleId = req.params.id;
  const sql = 'SELECT * FROM trending_articles WHERE id = ?';
  db.query(sql, [articleId], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    if (results.length === 0) return res.status(404).json({ error: 'Article not found' });
    res.json(results[0]);
  });
});

router.post('/', (req, res) => {
  const { title, summary, image_url } = req.body;
  if (!title || !summary) {
    return res.status(400).json({ error: 'Title and summary are required' });
  }

  const sql = 'INSERT INTO trending_articles (title, summary, image_url) VALUES (?, ?, ?)';
  db.query(sql, [title, summary, image_url || null], (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    res.status(201).json({ message: 'Trending article created', id: result.insertId });
  });
});


router.put('/:id', (req, res) => {
  const articleId = req.params.id;
  const { title, summary, image_url } = req.body;

  const sql = 'UPDATE trending_articles SET title = ?, summary = ?, image_url = ? WHERE id = ?';
  db.query(sql, [title, summary, image_url || null, articleId], (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    if (result.affectedRows === 0) return res.status(404).json({ error: 'Article not found' });
    res.json({ message: 'Trending article updated' });
  });
});


router.delete('/:id', (req, res) => {
  const articleId = req.params.id;
  const sql = 'DELETE FROM trending_articles WHERE id = ?';
  db.query(sql, [articleId], (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    if (result.affectedRows === 0) return res.status(404).json({ error: 'Article not found' });
    res.json({ message: 'Trending article deleted' });
  });
});

///  ===================================================================================================================================================





///GET detailed article
router.get('/detail', (req, res) => {
  db.query('SELECT * FROM trending_article_details', (err, results) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: 'Database error' });
    }
    res.json(results);
  });
});

// GET detailed article by trending_article_id
router.get('/detail/:id', (req, res) => {
  const id = req.params.id;
  db.query('SELECT * FROM trending_article_details WHERE trending_article_id = ?', [id], (err, results) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: 'Database error' });
    }
    if (results.length === 0) {
      return res.status(404).json({ error: 'Detail not found' });
    }
    res.json(results[0]);
  });
});
// POST create new detail
router.post('/detail', (req, res) => {
  const { trending_article_id, full_image_url, content } = req.body;

  if (!trending_article_id || !full_image_url || !content) {
    return res.status(400).json({ error: 'Missing required fields' });
  }

  const query = `INSERT INTO trending_article_details (trending_article_id, full_image_url, content)
                 VALUES (?, ?, ?)`;
  db.query(query, [trending_article_id, full_image_url, content], (err, result) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: 'Database error' });
    }
    res.status(201).json({ id: result.insertId, trending_article_id, full_image_url, content });
  });
});

// PUT update detail by trending_article_id
router.put('/detail/:id', (req, res) => {
  const id = req.params.id;
  const { full_image_url, content } = req.body;

  if (!full_image_url || !content) {
    return res.status(400).json({ error: 'Missing required fields' });
  }

  const query = `UPDATE trending_article_details 
                 SET full_image_url = ?, content = ? 
                 WHERE trending_article_id = ?`;
  db.query(query, [full_image_url, content, id], (err, result) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: 'Database error' });
    }
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Detail not found' });
    }
    res.json({ message: 'Detail updated successfully' });
  });
});

// DELETE detail by trending_article_id
router.delete('/detail/:id', (req, res) => {
  const id = req.params.id;
  db.query(
    'DELETE FROM trending_article_details WHERE trending_article_id = ?',
    [id],
    (err, result) => {
      if (err) {
        console.error(err);
        return res.status(500).json({ error: 'Database error' });
      }
      if (result.affectedRows === 0) {
        return res.status(404).json({ error: 'Detail not found' });
      }
      res.json({ message: 'Detail deleted successfully' });
    }
  );
});


module.exports = router;
