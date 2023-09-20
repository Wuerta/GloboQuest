import 'package:flutter/material.dart';
import 'package:globo_quest/models/destination.dart';
import 'package:globo_quest/services/places_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DestinationBottomSheet extends StatelessWidget {
  const DestinationBottomSheet({super.key, required this.destination});

  final Destination destination;

  String getFormattedDate(int milliseconds) {
    final date = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    final formattedDate = DateFormat("dd/MM/yyyy 'às' HH:mm").format(date);
    return 'Adicionado em: $formattedDate';
  }

  List<String> photos(BuildContext context) {
    final placesService = Provider.of<PlacesService>(context, listen: false);
    return placesService.getPhotos(destination.photos);
  }

  @override
  Widget build(BuildContext context) {
    final photos = this.photos(context);

    return SizedBox(
      height: double.maxFinite,
      width: double.maxFinite,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: photos.length,
              itemBuilder: (context, index) {
                final photo = photos[index];
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Image.network(
                    photo,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;

                      return Center(
                        child: CircularProgressIndicator(
                          value: (loadingProgress.expectedTotalBytes ?? 0) /
                              loadingProgress.cumulativeBytesLoaded,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        destination.name ?? '',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${destination.rating}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Icon(
                      Icons.star,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(destination.formattedAddress ?? ''),
                const SizedBox(height: 4),
                Text(
                  getFormattedDate(destination.createdAt),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
