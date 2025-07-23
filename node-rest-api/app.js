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

const userRoutes = require('./api/routes/usersRoute');
const articleRoutes = require('./api/routes/articlesRoute');

async function setupDatabase() {
  // 🧱 Setup users and roles
  await createRoleTable();
  await createUsersTable();
  await insertDefaultRoles();
  await insertAdmin();

  // 📰 Setup articles and article_detail
  await createArticlesTable();
  await createArticleDetailTable();
  await insertDefaultArticles(); // optional seed data
  await insertDefaultArticleDetails();

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

  await setupDatabase(); // ⬅️ Database is fully initialized here

  app.use('/api/users', userRoutes);
  app.use('/api/articles', articleRoutes);

  return app;
}

module.exports = createApp;
