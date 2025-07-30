const express = require('express');
const router = express.Router();
const db = require('../database/db');
const multer = require('multer');
const path = require('path');
// =============================
// 1. GET all articles (for homepage)
// =============================
router.get('/', (req, res) => {
  const baseUrl = 'http://localhost:3000/uploads'; // adjust as needed

  db.query('SELECT * FROM articles', (err, results) => {
    if (err) {
      console.error('DB error:', err);
      return res.status(500).json({ error: 'Database query error' });
    }

    // Map results to add full image URL
    const articles = results.map(article => ({
      ...article,
      imageUrl: article.image ? `${baseUrl}/${article.image}` : null,
    }));

    res.json(articles);
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

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/');
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, uniqueSuffix + path.extname(file.originalname));
  }
});

const upload = multer({ storage });

router.post('/full', upload.single('image'), async (req, res) => {
  const { title, summary, category_id, content, author } = req.body;
  const image = req.file?.filename;

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

      res.status(201).json({ message: 'Article and detail saved using one image' });
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

module.exports = router;
