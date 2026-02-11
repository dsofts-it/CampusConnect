import express from 'express';
const router = express.Router();
import {
  createUpdate,
  updateUpdate,
  deleteUpdate,
  getAllUpdates,
  likeUpdate,
} from '../controllers/update.controller.js';
import { auth, isTeacher } from '../middlewares/auth.js';

// Routes
// Teacher only routes
router.post('/', auth, isTeacher, createUpdate);
router.put('/:id', auth, isTeacher, updateUpdate);
router.delete('/:id', auth, isTeacher, deleteUpdate);

// Shared routes (Teacher & Student)
router.get('/', auth, getAllUpdates);
router.put('/:id/like', auth, likeUpdate);

export default router;
