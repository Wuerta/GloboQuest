import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:globo_quest/constants/assets.dart';
import 'package:globo_quest/services/auth_service.dart';
import 'package:globo_quest/services/destination_service.dart';
import 'package:globo_quest/widgets/destination_bottom_sheet.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DestinationsScreen extends StatelessWidget {
  const DestinationsScreen({super.key});

  String getFormattedDate(int milliseconds) {
    final date = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    final formattedDate = DateFormat("dd/MM/yyyy 'às' HH:mm").format(date);

    return 'Adicionado em: $formattedDate';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final destinationService = Provider.of<DestinationService>(context);
    final user = context.watch<AuthService>().user;
    if (user == null) return Container();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Meus Destinos',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.maxFinite,
            child: Card(
              margin: const EdgeInsets.all(0),
              elevation: 0,
              color: colors.tertiary,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: colors.onTertiary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Lembre sempre de se manter atualizado com as informações climáticas do destino!',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: colors.onTertiary,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: StreamBuilder(
              stream: destinationService.getDestinations(user.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final documents = snapshot.data!.docs;
                  final destinations = documents
                      .map(
                        (document) => document.data(),
                      )
                      .toList();

                  if (destinations.isEmpty) {
                    return Center(
                      child: SingleChildScrollView(
                        primary: false,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SvgPicture.asset(
                          Theme.of(context).brightness == Brightness.light
                              ? emptyStateLight
                              : emptyStateDark,
                          fit: BoxFit.cover,
                          width: 240,
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    primary: false,
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 80),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 16,
                    ),
                    itemCount: destinations.length,
                    itemBuilder: (_, index) {
                      final destination = destinations[index];

                      return Dismissible(
                        key: Key(destination.id),
                        onDismissed: (_) async {
                          await destinationService.removeDestination(
                            user.uid,
                            destination.id,
                          );
                        },
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          margin: const EdgeInsets.all(0),
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                clipBehavior: Clip.antiAlias,
                                constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.35,
                                ),
                                elevation: 0,
                                backgroundColor:
                                    ElevationOverlay.colorWithOverlay(
                                  Theme.of(context).colorScheme.surface,
                                  Theme.of(context).colorScheme.primary,
                                  2,
                                ),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(24),
                                    topRight: Radius.circular(24),
                                  ),
                                ),
                                builder: (_) => DestinationBottomSheet(
                                  destination: destination,
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        colors.primary,
                                        colors.primaryContainer,
                                      ],
                                    ),
                                  ),
                                  height: 16,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              destination.name ?? '',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '${destination.rating}',
                                            style: TextStyle(
                                              color: colors.primary,
                                            ),
                                          ),
                                          Icon(
                                            Icons.star,
                                            size: 16,
                                            color: colors.primary,
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
                          ),
                        ),
                      );
                    },
                  );
                }

                if (snapshot.hasError) {}

                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
