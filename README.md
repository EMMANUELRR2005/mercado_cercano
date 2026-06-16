# MercadoCercano

**Precios del mercado, en tu bolsillo.**

App móvil Flutter (Android + iOS) que digitaliza los precios del comercio
informal en Guatemala: los vendedores publican sus productos del día en
3 toques y los compradores encuentran precios, vendedores cercanos en un
mapa en tiempo real y un índice colaborativo de la canasta básica.

## Funcionalidades

| Rol | Funcionalidad |
|---|---|
| Ambos | Autenticación con Google, Apple y Email/Password, selector de rol, modo offline con banner, borrado de cuenta in-app |
| Vendedor | Publicar producto en 3 toques (foto → datos → confirmar), catálogo con vigencia de 24 h, "Renovar todo", marcar agotado, estadísticas con gráfica de vistas |
| Comprador | Búsqueda por categoría con filtros (radio, precio, rating), mapa con pins por categoría y updates en tiempo real, perfil de vendedor con llamada/WhatsApp |
| Comprador | Índice de precios por zona, historial con gráfica (Premium), alertas de precio (Premium), reporte ciudadano de precios, calificaciones y reseñas |

## Setup

Requisitos: Flutter 3.44+ (Dart 3.12).

```bash
flutter pub get
dart run build_runner build   # genera freezed/json

# Google Maps key (no versionada): copia los ejemplos y pon tu key
cp android/secrets.properties.example android/secrets.properties
cp ios/Flutter/Secrets.xcconfig.example ios/Flutter/Secrets.xcconfig

flutter run
```

La app corre **contra Firebase real** (proyecto `mercado-cercano-28190`):
Auth (Google/Apple/Email), Cloud Firestore, Storage y Messaging. Ya **no**
hay modo demo ni datasources mock. Para publicar en tiendas y la
configuración manual pendiente, ver **[MIGRATION.md](MIGRATION.md)** y
**[STORE_CHECKLIST.md](STORE_CHECKLIST.md)**.

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
│   ├── widgets/           # PriceTag, ProductCard, AppImage, etc.
│   └── screens/           # settings, legal (privacidad/términos)
├── features/
│   ├── auth/              # Google/Apple/Email, roles, splash/onboarding, borrado de cuenta
│   ├── vendor/            # publicar, catálogo, estadísticas (Firestore + Storage)
│   ├── buyer/             # búsqueda, detalle, perfil de vendedor, reportes
│   ├── price_index/       # índice, historial (Pro), alertas (Pro)
│   ├── map/               # mapa en tiempo real (Firestore streams)
│   └── reputation/        # calificaciones y reseñas
└── l10n/                  # es (default) + en
```

Cada feature: `data/` (datasources Firestore, models freezed+json,
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

## Configuración pendiente (para publicar en tiendas)

El detalle completo está en **[MIGRATION.md](MIGRATION.md)**. Resumen de lo
que solo puedes hacer tú (consolas, llaves, dominios):

- Rename del id a `gt.mercadocercano.app` + re-registro en Firebase.
- Habilitar Google/Apple/Email en Firebase Auth.
- Plan Blaze + bucket de Storage (hoy las fotos caen a base64 en Firestore).
- Keystore de release (`android/key.properties`).
- Rotar/restringir la Google Maps key; crear `secrets.properties` / `Secrets.xcconfig`.
- Agregar `PrivacyInfo.xcprivacy` al target Runner en Xcode.
- Publicar URLs reales de Privacidad/Términos.

Permisos nativos (ubicación *when-in-use*, cámara, galería, notificaciones)
están declarados con textos en español y se piden **en contexto**.

## Comandos útiles

```bash
flutter analyze                 # 0 issues
flutter build apk --debug       # build Android
dart run build_runner watch     # regenerar freezed/json al editar modelos
```
