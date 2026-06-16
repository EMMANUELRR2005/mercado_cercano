# MIGRATION.md — Producción y publicación en tiendas

Estado del repo tras esta migración y **pasos manuales que faltan** (los
que solo puedes hacer tú: consolas de Firebase/Apple/Google, llaves,
dominios). Fecha: 2026-06.

---

## 1. Lo que YA quedó en modo real (en código)

> La premisa de "salir del modo demo" estaba mayormente resuelta en
> commits previos. No existe `AppConstants.useMockData` ni datasources
> mock: la app corre solo contra Firebase.

- **Firebase init** activo en `lib/main.dart` (con fallback que evita
  crash si Firebase no está disponible).
- **Auth real**: Google + Apple + Email/Password (`auth_firebase_datasource.dart`).
  *(El SMS OTP fue retirado a propósito; ver decisión en §5.)*
- **Firestore** como backend de datos (`useFirestore = true`), datasources
  reales por feature; **reglas de producción** (`firestore.rules`) con auth
  obligatoria y ownership; **índices** en `firestore.indexes.json`.
- **Storage**: `FirebaseStorageService` con degradación a base64 en
  Firestore (porque el proyecto está en plan Spark; ver §4).
- **Ubicación del comprador**: solo en memoria, nunca se persiste.
- **Google Maps key**: externalizada fuera del repo (ver §3).
- **Borrado de cuenta in-app**, **pantallas legales**, **permiso de
  notificaciones en contexto**, **Privacy Manifest iOS**,
  **POST_NOTIFICATIONS** Android: añadidos en esta migración.

---

## 2. Rename del identificador de app (OBLIGATORIO antes de publicar)

Hoy el id sigue siendo `com.example.mercado_cercano` (Android) /
`com.example.mercadoCercano` (iOS) para **no romper el build** contra el
proyecto Firebase ya registrado. Google Play **rechaza `com.example.*`**.

**Secuencia exacta (hazla toda de una vez):**

1. En **Firebase Console** → tu proyecto `mercado-cercano-28190` →
   *Configuración* → *Tus apps*: agrega DOS apps nuevas con el id
   `gt.mercadocercano.app` (una Android, una iOS).
2. Cambia el id en el repo:
   - `android/app/build.gradle.kts` → `applicationId = "gt.mercadocercano.app"`.
   - iOS (Xcode → Runner → target Runner → *Signing & Capabilities*, o
     `ios/Runner.xcodeproj/project.pbxproj`): `PRODUCT_BUNDLE_IDENTIFIER`
     = `gt.mercadocercano.app` (y `...app.RunnerTests` para los tests).
3. Re-corre **`flutterfire configure`** → regenera `google-services.json`,
   `GoogleService-Info.plist` y `lib/firebase_options.dart` con el id nuevo.
4. **SHA-1 y SHA-256** del keystore (debug y release) → regístralas en la
   app Android nueva de Firebase (necesario para Google Sign-In).
5. iOS: pon el **REVERSED_CLIENT_ID** del nuevo `GoogleService-Info.plist`
   en `ios/Runner/Info.plist` → `CFBundleURLTypes` (reemplaza el actual).

Hasta completar 1–5, si cambias el id el build de Android fallará en el
paso `google-services` ("No matching client found").

---

## 3. Google Maps API key (ya externalizada — configura tu copia local)

La key ya **no está hardcodeada** en el repo. Se inyecta desde archivos
**no versionados**:

- **Android**: `android/secrets.properties` (lo lee `build.gradle.kts` y lo
  pasa al manifest como `${MAPS_API_KEY}`).
- **iOS**: `ios/Flutter/Secrets.xcconfig` (expone `$(MAPS_API_KEY)` →
  `GMSApiKey` en Info.plist → lo lee `AppDelegate.swift`).

**Qué debes hacer:**

1. En cada máquina/CI, copia los ejemplos y pon tu key:
   ```bash
   cp android/secrets.properties.example android/secrets.properties
   cp ios/Flutter/Secrets.xcconfig.example ios/Flutter/Secrets.xcconfig
   # edita ambos con tu MAPS_API_KEY
   ```
   *(En esta máquina ya quedaron creados con la key actual.)*
2. **Restringe** la key en Google Cloud Console: por nombre de paquete +
   SHA-1 (Android) y por bundle id (iOS).
3. **Rota la key**: la anterior estuvo commiteada en el historial de git.
   Genera una nueva, restríngela y reemplázala en los archivos de secretos.
4. Para usos desde Dart (si algún día usas Static Maps/Places):
   `flutter run --dart-define=MAPS_API_KEY=tu_key`.

---

## 4. Firebase Storage (fotos) — requiere plan Blaze

Hoy, sin bucket de Storage (plan Spark), las fotos se guardan como base64
dentro de Firestore (degradación automática). Para fotos reales en Storage:

1. Sube el proyecto a **plan Blaze** en Firebase.
2. Crea el bucket por defecto de Cloud Storage.
3. Despliega las reglas: `firebase deploy --only storage`.
   *(El código ya intenta Storage primero y cae a base64 si no existe.)*

---

## 5. Autenticación — decisión tomada

Se **mantiene Google + Apple + Email/Password** (NO se re-introdujo el SMS
OTP +502 que pedía el brief). Razón: ya es compatible con tiendas (Apple
Sign-In presente) y evita exigir Blaze + reCAPTCHA + APNs solo para phone-auth.

**Pendiente en Firebase Console** (Authentication → Sign-in method):
habilitar los 3 proveedores (Google, Apple, Email/Password) si aún no lo
están. Para Apple Sign-In: configurar el *Service ID* y la clave en
Apple Developer + Firebase.

---

## 6. Firma de release (Android) — crea tu keystore

`build.gradle.kts` ya usa `android/key.properties` si existe (si no, cae a
debug). **No subas el keystore ni `key.properties` al repo** (ya en `.gitignore`).

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
    -keyalg RSA -keysize 2048 -validity 10000 -alias upload
cp android/key.properties.example android/key.properties
# edita android/key.properties con tus contraseñas y la ruta absoluta al .jks
flutter build appbundle --release   # genera el .aab para Play
```
Recomendado: activa **Play App Signing** en Google Play Console.

---

## 7. iOS — Privacy Manifest y firma

- **`ios/Runner/PrivacyInfo.xcprivacy`** ya está creado con los datos que la
  app recolecta. **Falta agregarlo al target Runner en Xcode**: abre
  `ios/Runner.xcworkspace`, arrastra el archivo al proyecto (si no aparece) y
  marca *Target Membership → Runner*. Sin esto no se incluye en el bundle.
- **Firma**: necesitas cuenta de **Apple Developer**. En Xcode → Runner →
  *Signing & Capabilities*: equipo, perfil, y la capability **Sign in with
  Apple** (ya hay `sign_in_with_apple` en pubspec). Para FCM: sube la
  **APNs key** a Firebase Cloud Messaging.
- **Deployment target** iOS 15.0 (lo exige el SDK de Firebase). OK.

---

## 8. Política de Privacidad y Términos (URLs)

Hoy son **placeholders** en `AppConstants`:
`https://mercadocercano.gt/privacidad` y `/terminos`. La app ya los enlaza
desde el login y desde *Configuración → Privacidad y Términos*.

**Qué debes hacer:**
1. Publica los documentos reales en tu dominio.
2. Reemplaza las URLs: edita `AppConstants.privacyPolicyUrl` /
   `termsOfServiceUrl`, o pásalas en build con
   `--dart-define=PRIVACY_URL=... --dart-define=TERMS_URL=...`.
3. En **App Store Connect** y **Play Console**, pon la URL de privacidad en
   los metadatos (ambas tiendas la exigen).
4. Cambia `AppConstants.supportEmail` por tu correo real de soporte.

---

## 9. Resumen: checklist de lo que SOLO tú puedes hacer

- [ ] Rename a `gt.mercadocercano.app` + registrar apps en Firebase + `flutterfire configure` + SHA + REVERSED_CLIENT_ID (§2).
- [ ] Habilitar Google/Apple/Email en Firebase Auth (§5).
- [ ] Plan Blaze + bucket + `firebase deploy --only storage` (§4).
- [ ] Crear keystore + `android/key.properties` (§6).
- [ ] Rotar y restringir la Google Maps key (§3).
- [ ] Agregar `PrivacyInfo.xcprivacy` al target Runner en Xcode (§7).
- [ ] Cuenta Apple Developer + firma + APNs key (§7).
- [ ] Publicar y enlazar URLs reales de Privacidad/Términos + email de soporte (§8).
- [ ] Llenar Data Safety (Play) y App Privacy (Apple) — borradores en `STORE_CHECKLIST.md`.
