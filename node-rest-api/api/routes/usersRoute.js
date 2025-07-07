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
  const { username, email, password, role_id } = req.body;

  if (!username || !email || !password)
    return res.status(400).json({ message: 'All fields required' });

  // Optional: validate role_id, e.g. only allow 1, 2, or default 3
  const allowedRoles = [1, 2, 3];
  const assignedRole = allowedRoles.includes(role_id) ? role_id : 3;

  getUser(email, async (err, user) => {
    if (err) return res.status(500).json({ message: 'DB error' });
    if (user) return res.status(409).json({ message: 'Email already exists' });

    try {
      const hashedPassword = await bcrypt.hash(password, 10);
      insertUser({ username, email, password: hashedPassword, role_id: assignedRole }, err => {
        if (err) return res.status(500).json({ message: 'DB error' });
        res.status(201).json({ message: 'User registered' });
      });
    } catch (hashErr) {
      res.status(500).json({ message: 'Error hashing password' });
    }
  });
});


router.post('/login', (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) return res.status(400).json({ message: 'Missing fields' });

  getUser(email, async (err, user) => {
    if (!user) return res.status(404).json({ message: 'User not found' });

    const match = await bcrypt.compare(password, user.password);
    if (!match) return res.status(401).json({ message: 'Invalid password' });

    const token = jwt.sign({ id: user.id, email: user.email, role: user.role_title ,role_id:user.role_id}, process.env.JWT_SECRET, { expiresIn: '1h' });

    res.json({
        message: `Welcome! ${user.username} Role: ${user.role_id}`,
        token,
        role_id: user.role_id,
        user_id: user.id
    });

  });
});

router.get('/profile', verifyToken, (req, res) => {
  res.json({ message: 'Protected profile', user: req.user });
});

module.exports = router;