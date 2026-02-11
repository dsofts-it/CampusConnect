import 'dotenv/config';
import app from './app.js';
import connectDB from './config/db.js';
import keepAlive from './utils/keepAlive.js';

const PORT = process.env.PORT || 4000;

// Connect to database
connectDB();

const server = app.listen(PORT, () => {
  console.log(`App is running at ${PORT}`);
});

if (process.env.KEEP_ALIVE_URL) {
  keepAlive({
    url: process.env.KEEP_ALIVE_URL,
    interval: process.env.KEEP_ALIVE_INTERVAL_MS,
  });
}
