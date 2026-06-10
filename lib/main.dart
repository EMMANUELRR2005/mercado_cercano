import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/di/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO(firebase): el proyecto aún no tiene Firebase configurado
  // (faltan google-services.json, GoogleService-Info.plist y
  // firebase_options.dart). Cuando se ejecute `flutterfire configure`,
  // descomentar:
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  // Mientras tanto la app funciona 100% con mock data
  // (AppConstants.useMockData = true).

  // Cache local (Hive) para datos offline.
  await Hive.initFlutter();

  runApp(const ProviderScope(child: MercadoCercanoApp()));
}

/// Raíz de la app: tema, localización (es default / en) y router con
/// guard de autenticación.
class MercadoCercanoApp extends ConsumerWidget {
  const MercadoCercanoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'MercadoCercano',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}
