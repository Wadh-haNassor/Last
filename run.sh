#!/bin/bash

# Project setup
mkdir -p api/{controllers,models,routes,middleware,prisma}
cd api

# Initialize Node.js project
npm init -y
npm install express cors helmet morgan jsonwebtoken dotenv prisma @prisma/client

# Create Prisma schema
cat > prisma/schema.prisma << 'EOF'
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model User {
  id        String   @id @default(cuid())
  name      String
  email     String   @unique
  phone     String
  location  String?
  hotspots  Hotspot[]
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
}

model Hotspot {
  id          String   @id @default(cuid())
  name        String
  latitude    Float
  longitude   Float
  fishType    String
  rating      Int       @default(3)
  description String?
  lastUpdated DateTime  @default(now())
  createdBy   User      @relation(fields: [userId], references: [id])
  userId      String
  createdAt   DateTime  @default(now())
  updatedAt   DateTime  @updatedAt
}
EOF

# Create .env for DATABASE_URL
cat > .env << 'EOF'
DATABASE_URL="postgresql://user:password@localhost:5432/fisherman?schema=public"
JWT_SECRET="fisherman_secret"
PORT=5000
EOF

# Generate Prisma Client
npx prisma generate

# Create migration (for PostgreSQL)
echo "Run 'npx prisma migrate dev --name init' to create tables"

# Create controllers
cat > controllers/authController.js << 'EOF'
const jwt = require('jsonwebtoken');
const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();

exports.login = async (req, res) => {
  const { email, name, phone } = req.body;

  try {
    let user = await prisma.user.findUnique({ where: { email } });

    if (!user) {
      user = await prisma.user.create({
        data: { name, email, phone },
      });
    }

    const token = jwt.sign({ userId: user.id }, process.env.JWT_SECRET, {
      expiresIn: '1d',
    });

    res.json({ token, user });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
};
EOF

cat > controllers/hotspotController.js << 'EOF'
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

exports.getAllHotspots = async (req, res) => {
  try {
    const hotspots = await prisma.hotspot.findMany();
    res.json(hotspots);
  } catch (error) {
    res.status(500).json({ error: 'Server error' });
  }
};

exports.getHotspotById = async (req, res) => {
  try {
    const hotspot = await prisma.hotspot.findUnique({
      where: { id: req.params.id },
    });
    if (!hotspot) return res.status(404).json({ error: 'Hotspot not found' });
    res.json(hotspot);
  } catch (error) {
    res.status(500).json({ error: 'Server error' });
  }
};

exports.createHotspot = async (req, res) => {
  try {
    const hotspot = await prisma.hotspot.create({
      data: req.body,
    });
    res.status(201).json(hotspot);
  } catch (error) {
    res.status(500).json({ error: 'Server error' });
  }
};

exports.updateHotspot = async (req, res) => {
  try {
    const hotspot = await prisma.hotspot.update({
      where: { id: req.params.id },
      data: req.body,
    });
    res.json(hotspot);
  } catch (error) {
    res.status(500).json({ error: 'Server error' });
  }
};

exports.deleteHotspot = async (req, res) => {
  try {
    await prisma.hotspot.delete({ where: { id: req.params.id } });
    res.json({ message: 'Hotspot deleted' });
  } catch (error) {
    res.status(500).json({ error: 'Server error' });
  }
};

exports.searchByFishType = async (req, res) => {
  try {
    const hotspots = await prisma.hotspot.findMany({
      where: { fishType: { contains: req.params.fishType, mode: 'insensitive' } },
    });
    res.json(hotspots);
  } catch (error) {
    res.status(500).json({ error: 'Server error' });
  }
};
EOF

# Create routes
cat > routes/authRoutes.js << 'EOF'
const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');

router.post('/login', authController.login);
module.exports = router;
EOF

cat > routes/hotspotRoutes.js << 'EOF'
const express = require('express');
const router = express.Router();
const hotspotController = require('../controllers/hotspotController');

router.get('/', hotspotController.getAllHotspots);
router.get('/:id', hotspotController.getHotspotById);
router.post('/', hotspotController.createHotspot);
router.put('/:id', hotspotController.updateHotspot);
router.delete('/:id', hotspotController.deleteHotspot);
router.get('/search/:fishType', hotspotController.searchByFishType);

module.exports = router;
EOF

# Create server.js
cat > server.js << 'EOF'
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const dotenv = require('dotenv');
const authRoutes = require('./routes/authRoutes');
const hotspotRoutes = require('./routes/hotspotRoutes');

dotenv.config();

const app = express();
app.use(cors());
app.use(helmet());
app.use(morgan('dev'));
app.use(express.json());

app.use('/api/auth', authRoutes);
app.use('/api/hotspots', hotspotRoutes);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
EOF

# Make it executable
chmod +x setup-backend.sh