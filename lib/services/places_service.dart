import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:globo_quest/models/place.dart';
import 'package:globo_quest/models/place_prediction.dart';
import 'package:http/http.dart' as http;

class PlacesService {
  final placesApiKey = dotenv.env['PLACES_API_KEY'] ?? '';
  final customSearchApiContext = dotenv.env['CUSTOM_SEARCH_CONTEXT'] ?? '';

  Future<List<PlacePrediction>> searchPlaces(
    String query,
  ) async {
    final url = Uri(
      scheme: 'https',
      host: 'maps.googleapis.com',
      path: '/maps/api/place/autocomplete/json',
      queryParameters: {
        'key': placesApiKey,
        'input': Uri.encodeFull(query),
      },
    );

    final result = await http.get(url);
    final json = jsonDecode(result.body);
    final List<PlacePrediction> places = json['predictions']
        .map<PlacePrediction>(
            (candidate) => PlacePrediction.fromJson(candidate))
        .toList();
    return places;
  }

  Future<Place> getPlace(String id) async {
    final url = Uri(
      scheme: 'https',
      host: 'maps.googleapis.com',
      path: '/maps/api/place/details/json',
      queryParameters: {
        'key': placesApiKey,
        'place_id': id,
      },
    );

    final result = await http.get(url);
    final json = jsonDecode(result.body);
    return Place.fromJson(json['result']);
  }

  List<String> getPhotos(List<String> photos) {
    final photoUrls = <String>[];
    final length = photos.length > 3 ? 3 : photos.length;

    for (int index = 0; index < length; index++) {
      final url =
          'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&key=$placesApiKey&photo_reference=${photos[index]}';
      photoUrls.add(url);
    }

    return photoUrls;
  }
}
