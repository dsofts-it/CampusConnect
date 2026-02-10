import express from 'express';
const router = express.Router();
import { getProfile } from '../controllers/user.controller.js';
import { auth } from '../middlewares/auth.js';

router.get('/me', auth, getProfile);

export default router;
