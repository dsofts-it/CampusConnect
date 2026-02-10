import express from 'express';
import cors from 'cors';
import cookieParser from 'cookie-parser';
import morgan from 'morgan';

// Import Routes
import authRoutes from './routes/auth.routes.js';
import userRoutes from './routes/user.routes.js';
import updateRoutes from './routes/update.routes.js';

const app = express();

// Middleware
app.use(express.json());
app.use(cors());
app.use(cookieParser());
app.use(morgan('dev'));

// Mount Routes
app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use('/api/updates', updateRoutes);

// Default Route
app.get('/', (req, res) => {
  return res.json({
    success: true,
    message: 'Your server is up and running',
  });
});

export default app;
