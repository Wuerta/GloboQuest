import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:globo_quest/services/auth_service.dart';
import 'package:globo_quest/services/destination_service.dart';
import 'package:globo_quest/theme/custom_colors.dart';
import 'package:globo_quest/view_models/destination_view_model.dart';
import 'package:globo_quest/widgets/maps.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/assets.dart';

class SearchDestinationScreen extends StatefulWidget {
  const SearchDestinationScreen({super.key});

  @override
  State<SearchDestinationScreen> createState() =>
      _SearchDestinationScreenState();
}

class _SearchDestinationScreenState extends State<SearchDestinationScreen> {
  final _searchController = SearchController();
  late final _destinationViewModel = Provider.of<DestinationViewModel>(
    context,
    listen: false,
  );

  late final _destinationService = Provider.of<DestinationService>(
    context,
    listen: false,
  );

  @override
  void initState() {
    super.initState();
    _destinationViewModel.clearPlaces();
    _destinationViewModel.clearPlace();
    _searchController.addListener(searchPlace);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void searchPlace() {
    _destinationViewModel.searchPlace(_searchController.text);
  }

  void getPlace(String id) async {
    _destinationViewModel.getPlace(id);
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }

  Widget constraintedLayout({
    required BuildContext context,
    required BoxConstraints constraints,
    required Widget child,
  }) {
    return Column(
      children: [
        SizedBox(
          height:
              constraints.maxHeight < MediaQuery.of(context).viewInsets.bottom
                  ? constraints.maxHeight
                  : constraints.maxHeight -
                      MediaQuery.of(context).viewInsets.bottom,
          child: child,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final loadingPlace = context.watch<DestinationViewModel>().loadingPlace;
    final place = context.watch<DestinationViewModel>().place;
    final user = context.watch<AuthService>().user;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 72,
        elevation: 0,
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        systemOverlayStyle: CustomColors.of(context).systemUiOverlayStyle,
        title: SearchAnchor(
          searchController: _searchController,
          builder: (context, controller) {
            return SearchBar(
              elevation: const MaterialStatePropertyAll(2),
              controller: controller,
              padding: const MaterialStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 4),
              ),
              onTap: () {
                if (!controller.isOpen) {
                  controller.openView();
                }
              },
              onChanged: (_) {
                if (!controller.isOpen) {
                  controller.openView();
                }
              },
              hintText: 'Buscar destino',
              leading: const BackButton(),
              trailing: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                )
              ],
            );
          },
          viewBuilder: (_) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final places =
                    context.watch<DestinationViewModel>().searchedPlaces;
                final loading = context.watch<DestinationViewModel>().loading;

                if (loading) {
                  return constraintedLayout(
                    context: context,
                    constraints: constraints,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (places.isNotEmpty) {
                  return ListView.builder(
                    itemCount: places.length,
                    itemBuilder: (context, index) {
                      final place = places[index];
                      return ListTile(
                        title: Text(place.mainText),
                        subtitle: Text(place.secondaryText),
                        onTap: () {
                          setState(() {
                            _searchController.closeView(place.mainText);
                            getPlace(place.id);
                          });
                        },
                      );
                    },
                  );
                }

                return constraintedLayout(
                  context: context,
                  constraints: constraints,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 8,
                      ),
                      child: SvgPicture.asset(
                        Theme.of(context).brightness == Brightness.light
                            ? searchLight
                            : searchDark,
                        fit: BoxFit.cover,
                        width: 320,
                      ),
                    ),
                  ),
                );
              },
            );
          },
          suggestionsBuilder: (_, __) => [],
        ),
      ),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            children: [
              const Expanded(child: Maps()),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      width: 1,
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withOpacity(0.5),
                    ),
                  ),
                  color: Theme.of(context).colorScheme.background,
                ),
                height: place != null ? 200 : 0,
                padding: const EdgeInsets.all(16),
                child: place != null
                    ? Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          place.name ?? '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text('${place.rating}'),
                                      Icon(
                                        Icons.star,
                                        size: 16,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text('${place.formattedAddress}'),
                                  const SizedBox(height: 8),
                                  place.internationalPhoneNumber != null
                                      ? GestureDetector(
                                          onTap: () {
                                            launchUrl(
                                              Uri.parse(
                                                'tel:${place.internationalPhoneNumber}',
                                              ),
                                            );
                                          },
                                          child: Text(
                                            '${place.internationalPhoneNumber}',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () {
                                      launchUrl(Uri.parse(place.url!));
                                    },
                                    child: Text(
                                      '${place.url}',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.maxFinite,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (user == null) return;
                                final id = user.uid;
                                _destinationService.saveDestination(id, place);
                                context.go('/home');
                              },
                              child: const Text('Adicionar'),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
              ),
            ],
          ),
          loadingPlace
              ? Container(
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.8),
                  child: const Center(child: CircularProgressIndicator()),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
