const http = require('http');
require('dotenv').config();

const port = process.env.PORT || 3000;

// Import the async factory function from app.js
const createApp = require('./app');

async function startServer() {
  try {
    const app = await createApp();
    const server = http.createServer(app);

    server.listen(port, () => {
      console.log(`Server running at http://localhost:${port}`);
    });
  } catch (error) {
    console.error('Failed to start server:', error);
    process.exit(1);
  }
}

startServer();
