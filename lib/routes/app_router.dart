import 'package:flutter/material.dart';
import 'package:globo_quest/screens/auth/login_screen.dart';
import 'package:globo_quest/screens/home/home_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../screens/search_destination/search_destination_screen.dart';
import '../services/auth_service.dart';

final router = GoRouter(
  initialLocation: '/home',
  redirect: (context, state) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = await authService.getCurrentUser();

    if (state.path != null && state.path!.contains('/home') && user == null) {
      return '/login';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/home',
      builder: (_, __) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'search_destination',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: const SearchDestinationScreen(),
              transitionsBuilder: (_, animation, __, child) {
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOutCirc)
                      .animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/login',
      builder: (_, __) => const LoginScreen(),
    ),
  ],
);
