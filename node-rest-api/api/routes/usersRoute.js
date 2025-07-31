const express = require('express');
const db = require('../database/db');
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


// ✅ Admin-only route to register user/editor accounts
router.post('/admin-register', async (req, res) => {
  const { username, email, password, role } = req.body;
  console.log("📥 Received role from frontend:", role);


  // Validate inputs
  if (!username || !email || !password || !role) {
    return res.status(400).json({ message: 'All fields are required' });
  }

  // Role mapping
  const roleMap = {
    user: 3,
    editor: 2
  };

  const role_id = roleMap[role?.toLowerCase()] || 3;
  //const role_id = roleMap[roleKey];

  if (!role_id) {
    return res.status(400).json({ message: 'Invalid role provided. Must be "user" or "editor"' });
  }

  // Check if email already exists
  getUser(email, async (err, existingUser) => {
    if (err) return res.status(500).json({ message: 'Database error' });
    if (existingUser) return res.status(409).json({ message: 'Email already registered' });

    try {
      const hashedPassword = await bcrypt.hash(password, 10);
      insertUser({ username, email, password: hashedPassword, role_id }, (err) => {
        if (err) return res.status(500).json({ message: 'Insert failed' });
        res.status(201).json({ message: `User registered successfully as ${roleKey}` });
      });
    } catch (err) {
      console.error('Hashing error:', err);
      res.status(500).json({ message: 'Internal error during registration' });
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
        message: `Welcome! ${user.username}`,
        token,
        role_id: user.role_id,
        user_id: user.id
    });

  });
});

router.get('/profile', verifyToken, (req, res) => {
  res.json({ message: 'Protected profile', user: req.user });
});


router.put('/update-profile/:id', (req, res) => {
  const userId = req.params.id;
  const { full_name, address,email, phone_number, date_of_birth } = req.body;

  const sql = `
    UPDATE users SET 
      full_name = ?, 
      address = ?,
      email = ?,
      phone_number = ?, 
      date_of_birth = ?
    WHERE id = ?
  `;

  db.query(sql, [full_name, address,email, phone_number, date_of_birth, userId], (err, result) => {
    if (err) {
      console.error('Error updating user profile:', err);
      return res.status(500).json({ error: 'Database update error' });
    }
    return res.json({ success: true, message: 'Profile updated' });
  });
});

router.get('/profile/:id', (req, res) => {
  const userId = req.params.id;

  const sql = `
    SELECT id, username, full_name, address, email, phone_number, date_of_birth
    FROM users
    WHERE id = ?
  `;

  db.query(sql, [userId], (err, results) => {
    if (err) {
      console.error('Error fetching user profile:', err);
      return res.status(500).json({ error: 'Database query error' });
    }
    if (results.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }

    return res.json(results[0]);
  });
});



/// Get user account count number for using the app
router.get('/user-count', (req, res) => {
  const sql = 'SELECT COUNT(*) AS totalUsers FROM users';
  db.query(sql, (err, results) => {
    if (err) {
      console.error('Error querying DB:', err);
      return res.status(500).json({ error: 'Database error' });
    }
    res.json(results[0]); // => { totalUsers: 5 }
  });
});

router.get('/all-users', (req, res) => {
  const sql = `
    SELECT users.id, users.username, users.email, role_user.role_title 
    FROM users 
    JOIN role_user ON users.role_id = role_user.id
  `;

  db.query(sql, (err, results) => {
    if (err) {
      console.error('Error fetching users:', err);
      return res.status(500).json({ error: 'Database error' });
    }
    res.json(results); // array of users with roles
  });
});


// DELETE user by ID - only for user or editor roles (admin can delete)
router.delete('/delete/:id', (req, res) => {
  const userId = req.params.id;

  // Optional: You can add authorization middleware here to restrict access

  // First, check user's role
  const checkRoleSql = `SELECT role_id FROM users WHERE id = ?`;
  db.query(checkRoleSql, [userId], (err, results) => {
    if (err) return res.status(500).json({ message: 'DB error' });
    if (results.length === 0) return res.status(404).json({ message: 'User not found' });

    const roleId = results[0].role_id;
    if (roleId === 1) {
      // Admin role, forbid deletion
      return res.status(403).json({ message: 'Cannot delete admin users' });
    }

    // Proceed with deletion for user/editor only
    const deleteSql = `DELETE FROM users WHERE id = ?`;
    db.query(deleteSql, [userId], (err2) => {
      if (err2) return res.status(500).json({ message: 'Failed to delete user' });
      res.json({ message: 'User deleted successfully' });
    });
  });
});

router.post('/change-password', verifyToken, (req, res) => {
  const { oldPassword, newPassword } = req.body;
  const userId = req.user.id;

  if (!oldPassword || !newPassword) {
    return res.status(400).json({ message: 'Old and new passwords are required' });
  }

  getUser(req.user.email, async (err, user) => {
    if (err) {
      console.error('Database error:', err);
      return res.status(500).json({ message: 'Database error' });
    }

    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    const isMatch = await bcrypt.compare(oldPassword, user.password);
    if (!isMatch) {
      return res.status(401).json({ message: 'Invalid old password' });
    }

    try {
      const hashedPassword = await bcrypt.hash(newPassword, 10);

      const updateSql = 'UPDATE users SET password = ? WHERE id = ?';
      db.query(updateSql, [hashedPassword, userId], (updateErr) => {
        if (updateErr) {
          console.error('Password update error:', updateErr);
          return res.status(500).json({ message: 'Failed to update password' });
        }
        return res.json({ message: 'Password changed successfully' });
      });
    } catch (err) {
      console.error('Hashing error:', err);
      res.status(500).json({ message: 'Error hashing new password' });
    }
  });
});
module.exports = router;