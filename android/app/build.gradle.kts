import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Llave de firma release. NUNCA se commitea: ver android/key.properties.example.
// Si el archivo no existe, el build release cae a la firma debug (para que
// `flutter run --release` siga funcionando en desarrollo).
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

// Secretos no versionados (Google Maps API key). Ver android/secrets.properties.example.
// Prioridad: archivo local > variable de entorno > vacío (build sigue, mapa no renderiza).
val secretsProperties = Properties()
val secretsPropertiesFile = rootProject.file("secrets.properties")
if (secretsPropertiesFile.exists()) {
    secretsProperties.load(FileInputStream(secretsPropertiesFile))
}
val mapsApiKey: String =
    secretsProperties.getProperty("MAPS_API_KEY")
        ?: System.getenv("MAPS_API_KEY")
        ?: ""

android {
    namespace = "com.example.mercado_cercano"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // PRE-PUBLICACIÓN: cambiar a "gt.mercadocercano.app" tras registrar la
        // app en Firebase Console y re-correr flutterfire configure. Hoy se
        // mantiene com.example.* para que el build siga compilando contra el
        // proyecto Firebase ya registrado. Ver MIGRATION.md (paso "Rename").
        applicationId = "com.example.mercado_cercano"
        // Firebase Auth 6.x exige minSdk 23; no bajamos del default de Flutter.
        minSdk = maxOf(flutter.minSdkVersion, 23)
        // Play exige targetSdk reciente (34+); Flutter 3.44 ya entrega 35.
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // La Google Maps API key se inyecta en el manifest como ${MAPS_API_KEY}
        // (no se hardcodea en el repo).
        manifestPlaceholders["MAPS_API_KEY"] = mapsApiKey
    }

    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = (keystoreProperties["storeFile"] as String?)?.let { file(it) }
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            // Con key.properties presente firma con la llave de release;
            // si no, cae a debug (solo para desarrollo, NO para publicar).
            signingConfig = if (keystorePropertiesFile.exists()) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
