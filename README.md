# flutterCrossPlatform-Plaid

Research and Development repository for Flutter's Cross-Platform feature with PlaidLink.

### Commit-C001: "boilerplate set-up"

1. Created Flutter Project "flutterplaid" with the company name "example" and the project name "flutterplaid".
2. Cleaned up the counter format and set up the boilerplate.

### Commit-C002: "Dart Setup"

1. Created a `MethodChannel` named `customeplaidlink` which has to be unique. It can also be something like `flutterplaid/plaidlink`.
2. Created a function `showtoast` that invokes this channel, passing a parameter like `showtoast`.
3. Created an ElevatedButton which, when pressed, calls this function `showtoast`.

### Commit-C003: "Kotlin Setup"

1. Navigate to the `android` directory, right-click, and select "Open with Android Studio".
   - (You can also do this in VS Code, but Android Studio has a better auto-completer with the Android widgets for Kotlin and Java.)
2. Navigate to `android/app/src/main/kotlin/com/example/flutterplaid/MainActivity.kt`. Here, `example` is the company name and `flutterplaid` is the project name.
   - The package name `com.example.flutterplaid` is formed as follows: `com` is the domain extension, `example` is the company name, and `flutterplaid` is the project name. Also, `com.example` is actually `example.com`, the reverse domain URL of the company. For example, an app made by `google.app` will be `app.google`.
3. After navigating to `MainActivity.kt`, create a private variable with the exact channel name, here it would be `customeplaidlink`.
4. Type `override fun confi...` and it will auto-recommend:
   ```kotlin
   override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
       super.configureFlutterEngine(flutterEngine)
   }
   ```
5. Create the following inside `configureFlutterEngine()`:
   ```kotlin
   var channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
   ```
6. Create a Method Call Handler:
   ```kotlin
   channel.setMethodCallHandler { call, result ->
       if (call.method == "showToast") {
           Toast.makeText(this, "I work", Toast.LENGTH_LONG).show()
       }
   }
   ```
7. The `call.method` is the value passed to the channel from Dart/Flutter. If the parameter passed matches the Dart-passed value, it executes the task, which in our case is `showtoast`.
8. Formatted `README.md`.

### Commit-C004: "Plaid Dependencies"

1. Adding Dependency Directly to flutter. Normally 'pubspec.yaml' would do it automatically since we've added the flutter library but since we're adding Kotlin directly to the code we've gotta manually add dependencies to the project.

   ```java
   dependencies {
      implementation 'com.plaid.link:sdk-core:4.5.1'
   }
   ```

directly to "android\app\build.gradle"

- Latest version was obtained from [Reference](https://search.maven.org/artifact/com.plaid.link/sdk-core) In future when the changes are done in the depensency refer the latest version and changes.

2. Follow [Youtube](https://www.youtube.com/watch?v=oM7vL49I5tc) \*\*Didn't refer as last commit C005

3. TBC

### Commit-C005: "Plaid Flutter/Kotlin"

1. Got the Kotlin/Dart so editing the "main.dart" to fit the Dart
2. Have to make something like Learnt logs here. Did a lot of work for the past like 2 hours. So what I did? **Just the Work Logs, Included stuff I did that didn't work. To see code that worked skip to step '3'**

   - 1. Got the kotlin code from ChatGPT. (Spoiler Alert. It didn't work, Expected)
   - 2. Opened Android Studio in the 'android' directory, so edit the kotlin code and to check the syntax and error logs cause getting the kotlin extension in VS Code will take you to another different rabbit hole. Plus Android Studio can handle errors and missing files and configurations better, Which will come handy later.
   - 3. Got errors everywhere. Found out the error was that the plaid dependency wasn't added properly. A little piece of information. If working with Flutter/Kotlin in Platform Specific Code configuration, The recommened method to add the 'dependencies' is to open 'build.gradle' :app-level by navigating 'Gradle Scripts/build.gradle (Module :app)' in the file explorer section of Android Studio and type this out `dependencies { }` and hover on top of 'dependencies' will show a bulb. Click that and click Open or Just use the shortcut "ctrl+alt+shift+s" to open the 'Project Structure'. Navigate to Dependencies on the right and click + under the 'Declared Dependencies' and choose '1 Library Dependency' and Paste "com.plaid.link:sdk-core:4.5.1" and click Ok. This will download the dependency and import the package
   - 4. After that New error `est.kotlin_version=<latest Version>`. Fix Open "android\settings.gradle" and Navigate "id "org.jetbrains.kotlin.android" version "1.7.10" apply false" which can be found inside the plugins branch. Change it to the latest version [Kotlin Version](https://kotlinlang.org/docs/releases.html)
   - 5. After that Android Studio asked if it can update the android grable version and I gave use but it gave more problems than solving any. So skipped that except for 3 lines of code it suggested in the file "android\gradle.properties" added these three lines
        `android.defaults.buildfeatures.buildconfig=true
android.nonTransitiveRClass=false
android.nonFinalResIds=false` Have no idea why and what these do but it didn't throw any error figured will keep it as it is.
   - 6. After the Project Configuration was done and had to work on the code and Lo and behold the code ChatGPT was the error. Then Went throught the document and got the working current updated code. Now off to the Code Steps

3. Going throught step 2 will help to configure the project for this Flutter/Kotlin Plaid system.
4. Going to the Commit "Plaid Flutter/Kotlin" you can find the 'main.dart' and 'MainActivity.kt' files.

### Commit-C006: "pubspec.yaml fixes"

1. Ran "flutter pub get" and got some files fixed and new files generated.

### Commit-C007: "Plaid BugFixes-B01"

1. Hoping the bugs i'll encounter will be in two digit. Dont want to change the bug reference number to be three digit.
2. As of last commit the Plaid UI worked but had some internal problems.
3. The first I was able to recognize was:
   ```log
      W/cr_media( 4564): BLUETOOTH_CONNECT permission is missing.
      W/cr_media( 4564): getBluetoothAdapter() requires BLUETOOTH permission
      W/cr_media(32485): registerBluetoothIntentsIfNeeded: Requires BLUETOOTH permission
      W/le.flutterplaid(32485): Accessing hidden field
   ```
4. Added to "AndroidManifest.xml"

   ```xml
   <uses-permission android:name="android.permission.INTERNET"/>
   <uses-permission android:name="android.permission.BLUETOOTH"/>
   <uses-permission android:name="android.permission.BLUETOOTH_ADMIN"/>
   <uses-permission android:name="android.permission.BLUETOOTH_CONNECT"/>
   <uses-permission android:name="android.permission.BLUETOOTH_SCAN"/>
   ...
   <application
   ...
   android:enableOnBackInvokedCallback="true">
   ```

   and to "main.dart"

   ```dart
   import 'package:permission_handler/permission_handler.dart';

     Future<void> requestPermissions() async {
     final statusBluetoothConnect = await Permission.bluetoothConnect.request();
     final statusBluetoothScan = await Permission.bluetoothScan.request();

     // Check if permissions are granted
     if (statusBluetoothConnect.isGranted && statusBluetoothScan.isGranted) {
        print("Bluetooth permissions granted");
     } else {
        print("Bluetooth permissions denied");
     }
     }
   ```

   and to "pubspec.yaml"

   ```yaml
   permission_handler: ^11.3.1
   ```

   Manually changed the 'compileSdk' and 'targetSdk' version to 34 in App level 'build.gradle'

5. This fixed the bluetooth error. Yet have the Audio, Video Codec error, Here's the Error Logs [Flutter-Kotlin Plaid Error Log](https://docs.google.com/document/d/1FrRHykvOMjvO2Dy0DY7uf2G49EjuRuKQABAe36RZ-II/edit?usp=sharing)
