import 'package:google_maps_flutter/google_maps_flutter.dart';

class Place {
  const Place({
    required this.formattedAddress,
    required this.location,
    required this.internationalPhoneNumber,
    required this.name,
    required this.placeId,
    required this.rating,
    required this.url,
    required this.photos,
  });

  final String? formattedAddress;
  final LatLng location;
  final String? internationalPhoneNumber;
  final String? name;
  final String placeId;
  final double rating;
  final String? url;
  final List<String> photos;

  factory Place.fromJson(Map<String, dynamic> json) {
    final location = json['geometry']?['location'];
    return Place(
      formattedAddress: json['formatted_address'],
      location: location != null
          ? LatLng(location['lat'] ?? 0, location['lng'] ?? 0)
          : const LatLng(0, 0),
      internationalPhoneNumber: json['international_phone_number'],
      name: json['name'],
      placeId: json['place_id'],
      rating: json['rating'] ?? 5,
      url: json['url'],
      photos: json['photos'] != null
          ? json['photos']
              .map<String>((photo) => photo['photo_reference'] as String)
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "createdAt": DateTime.now().millisecondsSinceEpoch,
      "placeId": placeId,
      "name": name,
      "lat": location.latitude,
      "lng": location.longitude,
      "url": url,
      "rating": rating,
      "formattedAddress": formattedAddress,
      "internationalPhoneNumber": internationalPhoneNumber,
      "photos": photos,
    };
  }
}
