import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../services/hotspot_service.dart';
import '../services/location_service.dart';
import '../widgets/hotspot_info_card.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LocationService>(context, listen: false).getCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ramani ya Hotspots'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              final locationService = Provider.of<LocationService>(context, listen: false);
              locationService.getCurrentLocation();
              if (locationService.currentPosition != null) {
                _mapController.move(
                  LatLng(
                    locationService.currentPosition!.latitude,
                    locationService.currentPosition!.longitude,
                  ),
                  15,
                );
              }
            },
          ),
        ],
      ),
      body: Consumer2<HotspotService, LocationService>(
        builder: (context, hotspotService, locationService, child) {
          List<Marker> markers = hotspotService.hotspots.map((hotspot) {
            return Marker(
              point: LatLng(hotspot.latitude, hotspot.longitude),
              width: 40,
              height: 40,
              child: GestureDetector(
                onTap: () {
                  _showHotspotInfo(context, hotspot);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: _getRatingColor(hotspot.rating),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            );
          }).toList();

          // Add user location marker if available
          if (locationService.currentPosition != null) {
            markers.add(
              Marker(
                point: LatLng(
                  locationService.currentPosition!.latitude,
                  locationService.currentPosition!.longitude,
                ),
                width: 30,
                height: 30,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_pin_circle,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            );
          }

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: LatLng(-6.3690, 34.8207), // Tanzania center
                  initialZoom: 6,
                  minZoom: 3,
                  maxZoom: 18,
                ),
                children: [
                  TileLayer(
                    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: const ['a', 'b', 'c'],
                  ),
                  MarkerLayer(markers: markers),
                ],
              ),
              if (locationService.isLoading)
                const Positioned(
                  top: 16,
                  right: 16,
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 8),
                          Text('Kupata eneo...'),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddHotspotDialog(context);
        },
        child: const Icon(Icons.add_location),
      ),
    );
  }

  Color _getRatingColor(int rating) {
    switch (rating) {
      case 5:
        return Colors.green;
      case 4:
        return Colors.lightGreen;
      case 3:
        return Colors.orange;
      case 2:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showHotspotInfo(BuildContext context, hotspot) {
    showModalBottomSheet(
      context: context,
      builder: (context) => HotspotInfoCard(hotspot: hotspot),
    );
  }

  void _showAddHotspotDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ongeza Hotspot Mpya'),
        content: const Text('Utaweza kuongeza hotspot mpya kwa kubofya eneo la ramani na kujaza maelezo.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Sawa'),
          ),
        ],
      ),
    );
  }
}
