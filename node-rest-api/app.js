const express = require('express');
const bodyParser = require('body-parser');
const app = express();

const user = require('./api/routes/usersRoute');
const { createUsersTable } = require('./api/models/userModel');
const cors = require('cors');
app.use(cors());
// Middleware
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());
app.use(express.json());

// Routes
app.use('/users', user);

// Auto-create table on startup
createUsersTable();

module.exports = app;
