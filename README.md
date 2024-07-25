# flutterCrossPlatform-Plaid

Research and Development repository for Flutter's Cross-Platform feature with PlaidLink.

### Commit: "boilerplate set-up"

1. Created Flutter Project "flutterplaid" with the company name "example" and the project name "flutterplaid".
2. Cleaned up the counter format and set up the boilerplate.

### Commit: "Dart Setup"

1. Created a `MethodChannel` named `customeplaidlink` which has to be unique. It can also be something like `flutterplaid/plaidlink`.
2. Created a function `showtoast` that invokes this channel, passing a parameter like `showtoast`.
3. Created an ElevatedButton which, when pressed, calls this function `showtoast`.

### Commit: "Kotlin Setup"

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
