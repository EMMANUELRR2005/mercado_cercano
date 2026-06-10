import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../storage/secure_storage.dart';

/// Providers de infraestructura (Riverpod 3, `Provider<T>` manual como DI).
///
/// El estado de UI vive en BLoC; Riverpod aquí solo es el contenedor
/// de dependencias.

/// Almacenamiento seguro (JWT, rol, userId).
final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

/// Cliente HTTP con auth, refresh y backoff.
///
/// `onSessionExpired` puede sobreescribirse desde main con un override
/// que dispare la navegación al login.
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(secureStorage: ref.watch(secureStorageProvider));
});

/// Estado de conectividad.
final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl();
});
