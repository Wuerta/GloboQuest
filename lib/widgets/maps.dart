import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:globo_quest/view_models/destination_view_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../constants/assets.dart';
import '../theme/custom_colors.dart';

class Maps extends StatefulWidget {
  const Maps({super.key});

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  String? darkMap;

  final mapsController = Completer<GoogleMapController>();
  final searchController = SearchController();

  late Brightness mapsBrightness = Theme.of(context).brightness;

  @override
  void initState() {
    super.initState();
    loadDarkMapStyle();
  }

  Future<void> moveCamera(LatLng position) async {
    if (mapsController.isCompleted) {
      final controller = await mapsController.future;
      final camera = CameraUpdate.newLatLng(position);
      await controller.moveCamera(camera);
    }
  }

  Future<void> loadDarkMapStyle() async {
    final result = await rootBundle.loadString(darkMapStyle);
    darkMap = result;
  }

  Future<void> updateMapTheme(context) async {
    if (mapsController.isCompleted) {
      final controller = await mapsController.future;
      final brightness = CustomColors.of(context).brightness;
      final mapStyle = brightness == Brightness.dark ? darkMap : null;
      controller.setMapStyle(mapStyle);
    }
  }

  @override
  Widget build(BuildContext context) {
    final place = context.watch<DestinationViewModel>().place;

    if (place != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        moveCamera(place.location);
      });
    }

    if (mapsBrightness != Theme.of(context).brightness) {
      mapsBrightness = Theme.of(context).brightness;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        updateMapTheme(context);
      });
    }

    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: const CameraPosition(
        target: LatLng(-15.795995601003845, -47.96228378927236),
        zoom: 15,
      ),
      zoomControlsEnabled: false,
      rotateGesturesEnabled: false,
      scrollGesturesEnabled: true,
      compassEnabled: false,
      zoomGesturesEnabled: true,
      indoorViewEnabled: false,
      mapToolbarEnabled: false,
      myLocationEnabled: true,
      markers: place != null
          ? {
              Marker(
                markerId: MarkerId(place.placeId),
                position: place.location,
              )
            }
          : {},
      onMapCreated: (controller) {
        mapsController.complete(controller);
        updateMapTheme(context);
      },
      onTap: (argument) {
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      minMaxZoomPreference: const MinMaxZoomPreference(0, 18),
    );
  }
}
