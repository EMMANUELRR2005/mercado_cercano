# MercadoCercano

**Precios del mercado, en tu bolsillo.**

App móvil Flutter (Android + iOS) que digitaliza los precios del comercio
informal en Guatemala: los vendedores publican sus productos del día en
3 toques y los compradores encuentran precios, vendedores cercanos en un
mapa en tiempo real y un índice colaborativo de la canasta básica.

## Funcionalidades

| Rol | Funcionalidad |
|---|---|
| Ambos | Autenticación por SMS OTP (+502), selector de rol, modo offline con banner |
| Vendedor | Publicar producto en 3 toques (foto → datos → confirmar), catálogo con vigencia de 24 h, "Renovar todo", marcar agotado, estadísticas con gráfica de vistas |
| Comprador | Búsqueda por categoría con filtros (radio, precio, rating), mapa con pins por categoría y updates en tiempo real, perfil de vendedor con llamada/WhatsApp |
| Comprador | Índice de precios por zona, historial con gráfica (Premium), alertas de precio (Premium), reporte ciudadano de precios, calificaciones y reseñas |

## Setup

Requisitos: Flutter 3.44+ (Dart 3.12).

```bash
flutter pub get
dart run build_runner build   # genera freezed/json
flutter run
```

La app arranca en modo **demo** (`AppConstants.useMockData = true`):
funciona completa sin backend. Para probar el login usa cualquier
teléfono de 8 dígitos y el código OTP **123456**.

## Arquitectura

Clean Architecture por feature + BLoC para estado de UI + Riverpod 3
(providers manuales) como contenedor de DI.

```
lib/
├── core/                  # tema, red (Dio + refresh JWT), router (GoRouter),
│   │                      # errores, secure storage, utils, DI transversal
│   └── di/injection_container.dart   # appRouterProvider (guard de auth)
├── shared/
│   ├── domain/entities/   # ProductEntity, VendorEntity, UserEntity, PriceIndex…
│   ├── widgets/           # PriceTag, ProductCard, PremiumFeatureGate, etc. (14)
│   └── mock/mock_data_service.dart   # índice de todos los mocks
├── features/
│   ├── auth/              # OTP por SMS, roles, splash/onboarding
│   ├── vendor/            # publicar, catálogo, estadísticas
│   ├── buyer/             # búsqueda, detalle, perfil de vendedor, reportes
│   ├── price_index/       # índice, historial (Pro), alertas (Pro)
│   ├── map/               # mapa tiempo real (REST + WebSocket simulado)
│   └── reputation/        # calificaciones y reseñas
└── l10n/                  # es (default) + en
```

Cada feature: `data/` (datasources remote + mock, models freezed+json,
repository impl) · `domain/` (entities, repository abstracto, usecases) ·
`presentation/` (bloc, providers Riverpod, screens).

Convenciones:
- Datasources/repositorios lanzan `AppException`/`DioException`; el BLoC
  las mapea a `Failure` (mensajes en español) con `error_handler.dart`.
- JWT solo en `flutter_secure_storage`; la ubicación del comprador
  **nunca** se persiste (solo memoria, `UserLocationService`).
- Precios siempre `Q X.XX` en ámbar (`PriceTag` / `Formatters.formatQuetzal`).
- Monetización lista: `isFeatured`, `UserSubscription {free, pro, family}`
  y `PremiumFeatureGate` en historial y alertas.

## Configuración pendiente (para salir del modo demo)

| Qué | Dónde |
|---|---|
| URL del backend real | `AppConstants.baseUrl` y `wsUrl` + poner `useMockData = false` |
| Google Maps API key (Android) | `android/app/src/main/AndroidManifest.xml` → `com.google.android.geo.API_KEY` (hoy placeholder `YOUR_GOOGLE_MAPS_API_KEY`) |
| Google Maps API key (iOS) | `ios/Runner/AppDelegate.swift` → `GMSServices.provideAPIKey(...)` |
| Firebase | `flutterfire configure` (genera `firebase_options.dart`, `google-services.json`, `GoogleService-Info.plist`) y descomentar `Firebase.initializeApp` en `lib/main.dart` |

Permisos nativos (ubicación, cámara, galería) ya están declarados en el
AndroidManifest y el Info.plist con textos en español.

## Comandos útiles

```bash
flutter analyze                 # 0 issues
flutter build apk --debug       # build Android
dart run build_runner watch     # regenerar freezed/json al editar modelos
```
