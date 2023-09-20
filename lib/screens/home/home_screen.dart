import 'package:flutter/material.dart';
import 'package:globo_quest/screens/destinations/destinations_screen.dart';
import 'package:globo_quest/screens/profile/profile_screen.dart';
import 'package:globo_quest/services/auth_service.dart';
import 'package:globo_quest/theme/custom_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthService>().user;

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/login');
      });

      return Container();
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 24,
        systemOverlayStyle:
            CustomColors.of(context).systemUiOverlayStyle.copyWith(
                  systemNavigationBarColor: ElevationOverlay.colorWithOverlay(
                    Theme.of(context).colorScheme.surface,
                    Theme.of(context).colorScheme.primary,
                    2,
                  ),
                  systemNavigationBarDividerColor: Colors.transparent,
                ),
        forceMaterialTransparency: true,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 150),
        child: _currentPageIndex == 0
            ? const DestinationsScreen()
            : const ProfileScreen(),
      ),
      floatingActionButton: _currentPageIndex == 0
          ? FloatingActionButton(
              onPressed: () => context.go('/home/search_destination'),
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        selectedIndex: _currentPageIndex,
        backgroundColor: ElevationOverlay.colorWithOverlay(
          Theme.of(context).colorScheme.surface,
          Theme.of(context).colorScheme.primary,
          2,
        ),
        surfaceTintColor: Colors.transparent,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.travel_explore),
            label: 'Destinos',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
