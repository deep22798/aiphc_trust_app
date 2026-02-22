plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

//android {
//    namespace = "com.wintechwings.aipvst"
//    compileSdk = flutter.compileSdkVersion
////    ndkVersion = flutter.ndkVersion
//    ndkVersion = "29.0.14206865"
//
//    compileOptions {
//        sourceCompatibility = JavaVersion.VERSION_17
//        targetCompatibility = JavaVersion.VERSION_17
//    }
//
//    kotlinOptions {
//        jvmTarget = JavaVersion.VERSION_17.toString()
//    }
//
//    defaultConfig {
//        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
//        applicationId = "com.wintechwings.aipvst"
//        // You can update the following values to match your application needs.
//        // For more information, see: https://flutter.dev/to/review-gradle-config.
//        minSdk = flutter.minSdkVersion
//        targetSdk = flutter.targetSdkVersion
//        versionCode = flutter.versionCode
//        versionName = flutter.versionName
//    }
//
////    buildTypes {
////        release {
////            // TODO: Add your own signing config for the release build.
////            // Signing with the debug keys for now, so `flutter run --release` works.
////            signingConfig = signingConfigs.getByName("debug")
////        }
////    }
//    signingConfigs {
//        create("release") {
//            // If you don’t have a keystore yet, you can temporarily use debug keys:
//            storeFile = file("aiphcHce.jks")
//            storePassword = "aiphcHce"
//            keyAlias = "aiphcHce"
//            keyPassword = "aiphcHce"
//        }
//    }
//
//    buildTypes {
//        getByName("release") {
//            isMinifyEnabled = false
//            isShrinkResources = false
//            signingConfig = signingConfigs.getByName("release")
//        }
//    }

//}

android {
    namespace = "com.wintechwings.aipvst"
    compileSdk = flutter.compileSdkVersion

    // ✅ MUST use Flutter-stable NDK
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.wintechwings.aipvst"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = 1
        versionName = "1.0.0"
    }

    // ✅ THIS FIXES "failed to strip debug symbols"
    packagingOptions {
        jniLibs {
            useLegacyPackaging = true
            excludes += setOf("**/*.so.debug")
        }
    }

    signingConfigs {
        create("release") {
            storeFile = file("aipvst.jks")
            storePassword = "aipvst"
            keyAlias = "aipvst"
            keyPassword = "aipvst"
        }
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            isShrinkResources = false
            signingConfig = signingConfigs.getByName("release")

            // ✅ Disable native symbol stripping
//            ndk {
//                debugSymbolLevel = "NONE"
//            }

        }
    }
}
dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}

flutter {
    source = "../.."
}
