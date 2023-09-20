import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:globo_quest/routes/app_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:globo_quest/services/auth_service.dart';
import 'package:globo_quest/services/destination_service.dart';
import 'package:globo_quest/services/places_service.dart';
import 'package:globo_quest/view_models/destination_view_model.dart';
import 'package:globo_quest/view_models/login_view_model.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load();

  runApp(const GloboQuest());
}

class GloboQuest extends StatelessWidget {
  const GloboQuest({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        Provider<DestinationService>(create: (_) => DestinationService()),
        Provider<PlacesService>(create: (_) => PlacesService()),
        ChangeNotifierProvider(
          create: (context) => LoginViewModel(
            authService: Provider.of<AuthService>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => DestinationViewModel(
            placesService: Provider.of<PlacesService>(context, listen: false),
          ),
        ),
      ],
      child: GestureDetector(
        onTap: () {
          final currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
        },
        child: MaterialApp.router(
          title: 'GloboQuest',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0077B5),
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0077B5),
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          themeMode: ThemeMode.system,
          locale: const Locale('pt', 'BR'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          scrollBehavior: const ScrollBehavior().copyWith(
            physics: const BouncingScrollPhysics(),
          ),
          routerConfig: router,
        ),
      ),
    );
  }
}
