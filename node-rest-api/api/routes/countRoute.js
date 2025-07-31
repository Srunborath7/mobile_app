const express = require('express');
const router = express.Router();
const db = require('../database/db');

// GET /api/count/get-counts
router.get('/get-counts', (req, res) => {
  const query = `
    SELECT
      (SELECT COUNT(*) FROM articles) AS articleCount,
      (SELECT COUNT(*) FROM video_articles) AS videoArticleCount,
      (SELECT COUNT(*) FROM trending_articles) AS trendingArticleCount
  `;

  db.query(query, (err, results) => {
    if (err) {
      console.error('Database error:', err);
      return res.status(500).json({ error: 'Failed to get counts' });
    }

    res.json(results[0]); // return count values
  });
});

module.exports = router;
