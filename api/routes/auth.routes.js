// routes/auth.routes.js
import express from 'express';
import { register, login, forgotPassword } from '../controllers/authController.js';

const router = express.Router();

// POST /auth/register
router.post('/register', register);

// POST /auth/login
router.post('/login', login);

// POST /auth/forgot-password
router.post('/forgot-password', forgotPassword);

export default router;