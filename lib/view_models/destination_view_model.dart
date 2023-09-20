import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:globo_quest/models/place.dart';
import 'package:globo_quest/models/place_prediction.dart';
import 'package:globo_quest/services/places_service.dart';

class DestinationViewModel extends ChangeNotifier {
  DestinationViewModel({required this.placesService});

  final PlacesService placesService;

  List<PlacePrediction> _searchedPlaces = [];
  List<PlacePrediction> get searchedPlaces => _searchedPlaces;

  Place? _place;
  Place? get place => _place;

  String? _lastSearch;
  bool _loading = false;
  bool get loading => _loading;
  bool _loadingPlace = false;
  bool get loadingPlace => _loadingPlace;

  void clearPlaces() {
    _searchedPlaces = [];
  }

  void clearPlace() {
    _place = null;
  }

  void searchPlace(String value) {
    if (value != _lastSearch) {
      _loading = true;
      notifyListeners();

      if (value.trim().isEmpty) {
        _searchedPlaces = [];
        _loading = false;
        notifyListeners();
      }

      if (value.trim().isNotEmpty) {
        EasyDebounce.debounce(
          'searchPlacesDebouncer',
          const Duration(milliseconds: 1500),
          () async {
            final result = await placesService.searchPlaces(value);
            _searchedPlaces = result;
            _loading = false;
            notifyListeners();
          },
        );
      }

      _lastSearch = value;
    }
  }

  Future<void> getPlace(String id) async {
    _loadingPlace = true;

    try {
      final result = await placesService.getPlace(id);
      _place = result;
    } catch (error) {
      print(error);
    }

    _loadingPlace = false;
    notifyListeners();
  }
}
