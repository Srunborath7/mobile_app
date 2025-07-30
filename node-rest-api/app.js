const express = require('express');
const cors = require('cors');
require('dotenv').config();

const {
  createUsersTable,
  createRoleTable,
  insertDefaultRoles,
  insertAdmin,
} = require('./api/models/userModel');

const {
  createArticlesTable,
  createArticleDetailTable,
  insertDefaultArticles,
  insertDefaultArticleDetails,
} = require('./api/models/articleModel');

const {
  createVideoArticlesTable,
  insertDefaultVideoArticles,
} = require('./api/models/videoArticleModel');

const {
  createTrendingArticlesTable,
  createTrendingArticleDetailsTable
} = require('./api/models/trendingArticleModel');

const userRoutes = require('./api/routes/usersRoute');
const articleRoutes = require('./api/routes/articlesRoute');
const videoArticlesRoutes = require('./api/routes/video_article_Route');
const trendingArticlesRoutes = require('./api/routes/trending_article_Route');
require('./api/models/categoryModel'); 
const categories= require('./api/routes/categoryRoute');

async function setupDatabase() {
  // 🧱 Setup users and roles
  await createRoleTable();
  await createUsersTable();
  await insertDefaultRoles();
  await insertAdmin();

  // 📰 Setup articles and article_detail
  await createArticlesTable();
  await createArticleDetailTable();
  
  // Setup video_articles table and seed data
  await createVideoArticlesTable();
  await insertDefaultVideoArticles();

  // setup trending_articles table and insert data
  await createTrendingArticlesTable();
  await createTrendingArticleDetailsTable();
 

  console.log('✅ All tables and seed data are ready.');
}

async function createApp() {
  const app = express();

  app.use(cors({
    origin: '*',
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    allowedHeaders: ['Content-Type', 'Authorization'],
  }));

  app.use(express.json());

  await setupDatabase(); 

  app.use('/api/users', userRoutes);
  app.use('/api/articles', articleRoutes);
  app.use('/api/videos', videoArticlesRoutes);
  app.use('/api/trending', trendingArticlesRoutes);
  app.use('/api/categories', categories);
  app.use('/uploads', express.static('uploads'));
  return app;
}

module.exports = createApp;
