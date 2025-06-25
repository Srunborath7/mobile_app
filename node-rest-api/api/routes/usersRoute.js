const express = require('express');
const user = express.Router();
const { insertUser,getUser } = require('../models/userModel');
user.get('/',(req, res, next)=>{
    res.status(200).json({
        message:'User created'
    })
});
user.post('/login', (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ message: 'Please provide email and password' });
  }

  getUser(email, (err, result) => {
    if (err) {
      console.error('Get user error:', err);
      return res.status(500).json({ message: 'Error getting user' });
    }

    if (result.length === 0) {
      return res.status(404).json({ message: 'User not found' });
    }

    const userData = result[0];

    if (userData.password !== password) {
      return res.status(401).json({ message: 'Invalid password' });
    }

    res.status(200).json({
      message: `Welcome to my app ${userData.username}`,
      userId: userData.id
    });
  });
});
user.post('/register', (req, res) => {
  const { username, email, password } = req.body;

  if (!username || !email || !password) {
    return res.status(400).json({ message: 'Please provide username, email, and password' });
  }

  const user = { username, email, password };

  insertUser(user, (err, result) => {
    if (err) {
      console.error('Insert error:', err);
      return res.status(500).json({ message: 'Error inserting user' });
    }

    res.status(201).json({ message: 'User created successfully', userId: result.insertId });
  });
});
module.exports = user;