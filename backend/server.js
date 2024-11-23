const express = require('express');
const dotenv = require('dotenv');
const cors = require('cors');
const connectDB = require('./config/db');
const programRoutes = require('./routes/programRoutes');
const audioRoutes = require('./routes/audioRoutes');
const uploadRoutes = require('./routes/uploadRoutes');
const http = require('http');  // Import http module

// Load environment variables
dotenv.config();

// Connect to MongoDB
connectDB();

const app = express();

// Middleware
app.use(cors());
app.use(express.json({ limit: '20mb' }));

// Create server instance and set timeout
const server = http.createServer(app);
server.setTimeout(30000); // 30 seconds

// Routes
app.use('/api/upload', uploadRoutes);
app.use('/api/programs', programRoutes);
app.use('/api/audio', audioRoutes);

// Start the server
const PORT = process.env.PORT || 5000;
server.listen(PORT, () => console.log(`Server running on port ${PORT}`));
