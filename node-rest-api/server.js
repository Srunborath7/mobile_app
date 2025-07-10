const http = require('http');
const port = process.env.PORT || 3000;
const app = require('./app');
const server = http.createServer(app);
const cors = require('cors');
app.use(cors());
require('dotenv').config();
server.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
})