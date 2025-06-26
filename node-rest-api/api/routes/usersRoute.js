const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');
require('dotenv').config();
const jwt = require('jsonwebtoken');

const { insertUser, getUser } = require('../models/userModel');
const verifyToken = require('../middleware/auth');

router.get('/',(req, res, next)=>{
    res.status(200).json({
        message:'User created'
    })
});
router.post('/register', async (req, res) => {
  const { username, email, password } = req.body;
  if (!username || !email || !password)
    return res.status(400).json({ message: 'All fields required' });

  getUser(email, async (err, user) => {
    if (user) return res.status(409).json({ message: 'Email already exists' });
    const hashedPassword = await bcrypt.hash(password, 10);
    insertUser({ username, email, password: hashedPassword }, err => {
      if (err) return res.status(500).json({ message: 'DB error' });
      res.status(201).json({ message: 'User registered' });
    });
  });
});

router.post('/login', (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) return res.status(400).json({ message: 'Missing fields' });

  getUser(email, async (err, user) => {
    if (!user) return res.status(404).json({ message: 'User not found' });

    const match = await bcrypt.compare(password, user.password);
    if (!match) return res.status(401).json({ message: 'Invalid password' });

    const token = jwt.sign({ id: user.id, email: user.email, role: user.role_title }, process.env.JWT_SECRET, { expiresIn: '1h' });

    res.json({ message: `Welcome ${user.username}`, token });
  });
});

router.get('/profile', verifyToken, (req, res) => {
  res.json({ message: 'Protected profile', user: req.user });
});

module.exports = router;