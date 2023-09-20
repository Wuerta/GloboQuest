import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:globo_quest/constants/assets.dart';
import 'package:globo_quest/services/auth_service.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthService>().user;
    if (user == null) return Container();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.maxFinite,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Meu Perfil',
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              width: 144,
              height: 144,
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.transparent,
                foregroundImage:
                    user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                child: user.photoURL != null
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : SvgPicture.asset(
                        Theme.of(context).brightness == Brightness.light
                            ? userLight
                            : userDark,
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.displayName ?? 'Sem nome',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 4),
            Text(user.email ?? 'Sem e-mail'),
            const SizedBox(height: 16),
            const Spacer(),
            SizedBox(
              width: 180,
              child: ElevatedButton(
                onPressed: () async {
                  final authService = Provider.of<AuthService>(
                    context,
                    listen: false,
                  );
                  await authService.logout();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.errorContainer,
                  foregroundColor:
                      Theme.of(context).colorScheme.onErrorContainer,
                ),
                child: const Text('Logout'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
