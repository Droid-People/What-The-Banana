import java.util.Locale
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Properties
import java.util.TimeZone

val myDirName = SimpleDateFormat("yyyyMMdd")
myDirName.timeZone = TimeZone.getDefault()
val copyDir = File("../../../Release/", myDirName.format(Date()))

plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "people.droid.untitled"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "people.droid.untitled"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            val keystorePropertiesFile = rootProject.file("app/keystore/keystore.properties")
            val keystoreProperties = Properties().apply {
                load(keystorePropertiesFile.reader())
            }
            storeFile = file(keystoreProperties["storePath"].toString())
            storePassword = keystoreProperties["storePassword"].toString()
            keyAlias = keystoreProperties["keyAlias"].toString()
            keyPassword = keystoreProperties["keyPassword"].toString()
        }
    }

    applicationVariants.configureEach {
        outputs.all { variant ->
            if (variant.outputFile.name.contains("release")) {
                val taskSuffix =
                    name.replaceFirstChar { if (it.isLowerCase()) it.titlecase(Locale.getDefault()) else it.toString() }
                val assembleTaskName = "bundle$taskSuffix"
                val task = tasks.findByName(assembleTaskName)
                if (task != null) {
                    val copyTask = tasks.create("archive${taskSuffix}Copy", Copy::class) {
                        description = "앱번들 복사하기"
                        println(description)
                        from("build/outputs/bundle/release/app-release.aab")
                        into(copyDir.absolutePath)
                        include("*.aab")
                        includeEmptyDirs = false
                        rename { fileName ->
                            fileName.replace(
                                "app-release.aab",
                                "Untitled_${versionName}.aab"
                            )
                        }
                    }
                    tasks.getByName(assembleTaskName).finalizedBy(copyTask)
                }
            }
            return@all true
        }
    }

    buildTypes {
        getByName("release") {
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            signingConfig = signingConfigs.getByName("release")
        }
        getByName("debug") {
            isMinifyEnabled = false
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}
