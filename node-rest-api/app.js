const express = require('express');
const app = express();
const userRoutes = require('./api/routes/usersRoute');
const articleRoutes = require('./api/routes/articlesRoute'); // ✅ Add this line



require('dotenv').config();
const cors = require('cors');
app.use(cors({
  origin: '*', // or set specific IP like 'http://localhost:3000'
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));
const {
  createUsersTable,
  createRoleTable,
  insertDefaultRoles,
  insertAdmin
} = require('./api/models/userModel');

app.use(express.json());

createRoleTable();
createUsersTable();
insertDefaultRoles();
insertAdmin();

app.use('/api/users', userRoutes);
app.use('/api/articles', articleRoutes);



module.exports = app;
