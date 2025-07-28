import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/hotspot_service.dart';
import '../widgets/hotspot_card.dart';

class HotspotListScreen extends StatelessWidget {
  const HotspotListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotspots Zote'),
      ),
      body: Consumer<HotspotService>(
        builder: (context, hotspotService, child) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: hotspotService.hotspots.length,
            itemBuilder: (context, index) {
              final hotspot = hotspotService.hotspots[index];
              return HotspotCard(hotspot: hotspot);
            },
          );
        },
      ),
    );
  }
}
