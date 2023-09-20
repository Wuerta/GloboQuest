import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:globo_quest/models/place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final class Destination extends Place {
  const Destination({
    required this.id,
    required this.createdAt,
    required super.name,
    required super.placeId,
    required super.location,
    required super.url,
    required super.rating,
    required super.formattedAddress,
    required super.internationalPhoneNumber,
    required super.photos,
  });

  final String id;
  final int createdAt;

  factory Destination.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? _,
  ) {
    final id = snapshot.id;
    final data = snapshot.data();

    return Destination(
      id: id,
      name: data?['name'],
      createdAt: data?['createdAt'] ?? 0,
      url: data?['url'],
      placeId: data?['placeId'],
      location: LatLng(data?['lat'] ?? 0, data?['lng'] ?? 0),
      rating: data?['rating'],
      formattedAddress: data?['formattedAddress'],
      internationalPhoneNumber: data?['internationalPhoneNumber'],
      photos: data?['photos'].cast<String>() ?? const [],
    );
  }
}
