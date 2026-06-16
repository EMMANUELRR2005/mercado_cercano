# STORE_CHECKLIST.md — App Store + Google Play

Estado de cada requisito de revisión. Leyenda:
✅ hecho en código · 🟡 hecho, requiere acción manual tuya · ⬜ pendiente (tú).

---

## General (ambas tiendas)

| Requisito | Estado | Nota |
|---|---|---|
| Google Maps key fuera del repo | ✅ | Inyectada desde `secrets.properties` / `Secrets.xcconfig` (no versionados). Rota y restringe la key — MIGRATION §3 |
| Borrado de cuenta in-app | ✅ | *Configuración → Borrar mi cuenta*. Borra datos en Firestore + cuenta Auth, con reautenticación Google/Apple |
| Sign in with Apple presente | ✅ | `sign_in_with_apple`; verificar firma/capability en Xcode — MIGRATION §7 |
| Política de Privacidad + Términos accesibles | 🟡 | Pantalla `LegalScreen` + links desde login y settings; URLs son **placeholder** — MIGRATION §8 |
| Permisos en contexto (no al inicio) | ✅ | Notificaciones se piden al entrar a Alertas; ubicación al abrir el mapa; cámara al publicar |
| Estados offline y vacíos | ✅ | `OfflineBanner`, `EmptyStateWidget`, `ErrorStateWidget` en todas las pantallas |
| Purpose strings claros en español | ✅ | Info.plist (iOS) y permisos Android |

## iOS / App Store

| Requisito | Estado | Nota |
|---|---|---|
| `NSLocationWhenInUseUsageDescription` | ✅ | Texto en español. Se **quitaron** las claves *Always* (sin ubicación en background) |
| `NSCameraUsageDescription` / `NSPhotoLibraryUsageDescription` | ✅ | En español |
| `NSMicrophoneUsageDescription` | ✅ | **Eliminado** (la app no graba audio/video) |
| `PrivacyInfo.xcprivacy` (Privacy Manifest) | 🟡 | Creado en `ios/Runner/`; **agrégalo al target Runner en Xcode** — MIGRATION §7 |
| Bundle id de producción | ⬜ | Rename a `gt.mercadocercano.app` — MIGRATION §2 |
| Deployment target | ✅ | iOS 15.0 |
| Firma / Apple Developer / APNs | ⬜ | MIGRATION §7 |
| URL de privacidad en App Store Connect | ⬜ | MIGRATION §8 |
| App Privacy "Nutrition Labels" | ⬜ | Borrador abajo |

## Android / Google Play

| Requisito | Estado | Nota |
|---|---|---|
| `applicationId` ≠ `com.example.*` | ⬜ | Rename — MIGRATION §2 |
| `POST_NOTIFICATIONS` (Android 13+) | ✅ | En AndroidManifest |
| Sin ubicación en background | ✅ | Solo `ACCESS_FINE/COARSE_LOCATION` (foreground) |
| `minSdk` / `targetSdk` | ✅ | `minSdk` 23 (Firebase Auth); `targetSdk` = default de Flutter (35, cumple Play) |
| Firma de release (keystore propio) | 🟡 | `build.gradle.kts` lee `key.properties`; créalo — MIGRATION §6 |
| Data Safety form | ⬜ | Borrador abajo |

---

## Borrador — App Privacy (Apple) / Data Safety (Google)

Basado en los datos que la app **realmente** maneja.

### Datos recolectados (transmitidos fuera del dispositivo)

| Dato | ¿Se recolecta? | Vinculado a identidad | Propósito | Tracking |
|---|---|---|---|---|
| Email | Sí | Sí | Funcionalidad (cuenta) | No |
| Nombre | Sí | Sí | Funcionalidad (perfil) | No |
| Foto de perfil/productos | Sí | Sí | Funcionalidad | No |
| Teléfono (vendedor) | Sí | Sí | Funcionalidad (contacto) | No |
| Ubicación precisa **del negocio (vendedor)** | Sí | Sí | Funcionalidad (mostrar en mapa) | No |
| Ubicación **del comprador** | **No** | — | Solo en memoria, nunca se almacena ni transmite a nuestros servidores | No |
| Reportes de precio (contenido) | Sí | **No** (anónimos) | Índice colaborativo | No |
| Identificadores (FCM token) | Sí | Sí | Notificaciones de alertas | No |

### Puntos clave para los formularios
- **No** hay tracking entre apps/empresas → ATT no aplica; `NSPrivacyTracking=false`.
- La ubicación del comprador se declara como **no recolectada** (uso efímero en memoria).
- Borrado de cuenta y datos disponible **dentro de la app** (Apple Guideline 5.1.1(v); Google "Eliminación de cuenta").
- Métodos de borrado de datos: in-app + email de soporte (`AppConstants.supportEmail`).

### APIs de motivo requerido (iOS, en `PrivacyInfo.xcprivacy`)
- `UserDefaults` → `CA92.1`
- `File timestamp` → `C617.1`
- *(Los plugins de terceros declaran las suyas en sus propios manifests.)*

---

## Verificación técnica
- `flutter analyze` → **0 issues**.
- `flutter build apk --debug` → **OK**.
- `flutter build ios` → requiere macOS + firma; verificar tras MIGRATION §2 y §7.
