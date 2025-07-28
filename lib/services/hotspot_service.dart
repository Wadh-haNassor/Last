import 'package:flutter/material.dart';
import '../models/hotspot.dart';

class HotspotService extends ChangeNotifier {
  final List<Hotspot> _hotspots = [
    Hotspot(
      id: '1',
      name: 'Kilifi Creek',
      latitude: -3.6307,
      longitude: 39.8495,
      fishType: 'Tilapia, Snapper',
      rating: 4,
      description: 'Rich fishing area with good tidal flow',
      lastUpdated: DateTime.now(),
    ),
    Hotspot(
      id: '2',
      name: 'Mombasa Old Port',
      latitude: -4.0435,
      longitude: 39.6682,
      fishType: 'Kingfish, Barracuda',
      rating: 5,
      description: 'Deep water fishing spot',
      lastUpdated: DateTime.now(),
    ),
    Hotspot(
      id: '3',
      name: 'Dar es Salaam Harbor',
      latitude: -6.7924,
      longitude: 39.2083,
      fishType: 'Tuna, Sailfish',
      rating: 3,
      description: 'Good for early morning fishing',
      lastUpdated: DateTime.now(),
    ),
    Hotspot(
      id: '4',
      name: 'Zanzibar Stone Town',
      latitude: -6.1659,
      longitude: 39.2026,
      fishType: 'Red Scanner, Grouper',
      rating: 4,
      description: 'Popular tourist and fishing area',
      lastUpdated: DateTime.now(),
    ),
    Hotspot(
      id: '5',
      name: 'Pemba Island',
      latitude: -5.1667,
      longitude: 39.7500,
      fishType: 'Marlin, Dorado',
      rating: 5,
      description: 'Excellent deep sea fishing',
      lastUpdated: DateTime.now(),
    ),
  ];

  List<Hotspot> get hotspots => List.unmodifiable(_hotspots);

  void addHotspot(Hotspot hotspot) {
    _hotspots.add(hotspot);
    notifyListeners();
  }

  void removeHotspot(String id) {
    _hotspots.removeWhere((hotspot) => hotspot.id == id);
    notifyListeners();
  }

  List<Hotspot> getHotspotsByFishType(String fishType) {
    return _hotspots
        .where((hotspot) => 
            hotspot.fishType.toLowerCase().contains(fishType.toLowerCase()))
        .toList();
  }
}
