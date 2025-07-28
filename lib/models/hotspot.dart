class Hotspot {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String fishType;
  final int rating;
  final String description;
  final DateTime lastUpdated;

  Hotspot({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.fishType,
    required this.rating,
    required this.description,
    required this.lastUpdated,
  });

  factory Hotspot.fromJson(Map<String, dynamic> json) {
    return Hotspot(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      fishType: json['fishType'],
      rating: json['rating'],
      description: json['description'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }
}
