const express = require('express');
const router = express.Router();
const db = require('../database/db');


router.get('/', (req, res) => {
  const sql = 'SELECT * FROM categories';
  db.query(sql, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});
router.get('/article/:id', (req, res) => {
  const articleId = req.params.id;

  const sql = `
    SELECT a.*, c.name as category_name
    FROM articles a
    JOIN categories c ON a.category_id = c.id
    WHERE a.id = ?
  `;

  db.query(sql, [articleId], (err, results) => {
    if (err) return res.status(500).json({ error: err.message });

    if (results.length === 0) return res.status(404).json({ error: 'Article not found' });

    res.json(results[0]);
  });
});



router.get('/article/category/:categoryId', (req, res) => {
  const categoryId = req.params.categoryId;
  const sql = `
    SELECT a.*, c.name AS category_name
    FROM articles a
    JOIN categories c ON a.category_id = c.id
    WHERE a.category_id = ?
  `;
  db.query(sql, [categoryId], (err, results) => {
    if (err) return res.status(500).json({ error: 'Query error', details: err.message });
    res.json(results);
  });
});

module.exports = router;