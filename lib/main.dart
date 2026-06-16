import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/di/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase (proyecto mercado-cercano-28190): Auth (Google/Apple/Email),
  // Cloud Firestore, Storage y Messaging. Si Firebase no está disponible
  // (p. ej. emulador sin Google Play), la app no crashea: el catch deja
  // que arranque y los flujos que dependen de Firebase fallan con gracia.
  //
  // NOTA: el permiso de notificaciones NO se pide aquí. Se solicita EN
  // CONTEXTO al entrar a Alertas (ver PushNotificationService), como
  // exigen las guías de App Store y Google Play.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase no disponible: $e');
  }

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
