const express = require('express');
const router = express.Router();
const authMiddleware = require('../middleware/authMiddleware.js');
const hotspotController = require('../controllers/hotspotController.js');

// @route   GET /api/hotspots
// @desc    Get all hotspots
router.get('/', hotspotController.getHotspots);

// @route   GET /api/hotspots/:id
// @desc    Get single hotspot
router.get('/:id', hotspotController.getHotspotById);

// @route   POST /api/hotspots
// @desc    Create new hotspot
router.post('/', authMiddleware, hotspotController.createHotspot);

module.exports = router;
