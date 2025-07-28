const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

// Create new hotspot
exports.createHotspot = async (req, res) => {
  try {
    const { name, description, latitude, longitude, rating, fishSpecies } = req.body;
    
    const newHotspot = await prisma.hotspot.create({
      data: {
        name,
        description,
        latitude,
        longitude,
        rating,
        fishSpecies,
        createdById: req.user.id
      }
    });
    
    res.status(201).json(newHotspot);
  } catch (error) {
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// Get all hotspots
exports.getHotspots = async (req, res) => {
  try {
    const hotspots = await prisma.hotspot.findMany({
      include: {
        createdBy: {
          select: {
            name: true
          }
        }
      }
    });
    res.json(hotspots);
  } catch (error) {
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// Get single hotspot
exports.getHotspotById = async (req, res) => {
  try {
    const hotspot = await prisma.hotspot.findUnique({
      where: { id: parseInt(req.params.id) },
      include: {
        createdBy: {
          select: {
            name: true
          }
        }
      }
    });
    
    if (!hotspot) {
      return res.status(404).json({ message: 'Hotspot not found' });
    }
    res.json(hotspot);
  } catch (error) {
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};
