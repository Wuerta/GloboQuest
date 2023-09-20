import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:globo_quest/models/destination.dart';
import 'package:globo_quest/models/place.dart';

class DestinationService {
  DestinationService();

  final _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Destination>> getDestinations(String id) {
    final reference = _firestore.collection('/users/$id/destinations/');
    return reference
        .withConverter(
          fromFirestore: Destination.fromFirestore,
          toFirestore: (destination, _) => destination.toFirestore(),
        )
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> saveDestination(String id, Place place) async {
    final reference = _firestore.collection('/users/$id/destinations/');
    await reference.add(place.toFirestore());
  }

  Future<void> removeDestination(String userId, String destinationId) async {
    final reference = _firestore.doc(
      '/users/$userId/destinations/$destinationId',
    );
    await reference.delete();
  }
}
