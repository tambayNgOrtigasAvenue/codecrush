plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.codecrush.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.codecrush.app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Replace with a proper signing config before publishing to Play Store.
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    // ── Rename APK output to: codecrush-{versionName}-android.apk ──────────
    applicationVariants.all {
        val variant = this
        val versionName = variant.versionName ?: "1.0.0"
        val buildType   = variant.buildType.name          // "release" or "debug"
        val apkName     = "codecrush-${versionName}-android.apk"

        tasks.named("assemble${variant.name.replaceFirstChar { it.uppercase() }}") {
            doLast {
                val outputDir = file("${buildDir}/outputs/flutter-apk")
                val source    = File(outputDir, "app-${buildType}.apk")
                val target    = File(outputDir, apkName)
                if (source.exists()) {
                    source.copyTo(target, overwrite = true)
                    println("APK copied → ${target.name}")
                }
            }
        }
    }
}

flutter {
    source = "../.."
}
