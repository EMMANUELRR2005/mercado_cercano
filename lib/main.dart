import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/di/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase (proyecto mercado-cercano-28190): Auth por teléfono/SMS,
  // Cloud Firestore y Cloud Messaging. Si Firebase no está disponible
  // (p. ej. emulador sin Google Play), la app sigue funcionando en modo
  // demo con mock data.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await _initPushNotifications();
  } catch (e) {
    debugPrint('Firebase no disponible: $e');
  }

  // Cache local (Hive) para datos offline.
  await Hive.initFlutter();

  runApp(const ProviderScope(child: MercadoCercanoApp()));
}

/// Firebase Cloud Messaging: pide permiso de notificaciones y registra
/// el token del dispositivo (en producción se enviaría al backend para
/// las alertas de precio).
Future<void> _initPushNotifications() async {
  final messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();
  if (kDebugMode) {
    // En iOS requiere APNs configurado; por eso va dentro del try/catch
    // de main.
    final token = await messaging.getToken();
    debugPrint('FCM token: $token');
  }
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
