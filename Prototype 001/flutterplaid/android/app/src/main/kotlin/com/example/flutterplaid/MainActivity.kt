package com.example.flutterplaid

import android.content.Context
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.plaid.link.Plaid
import com.plaid.link.configuration.LinkTokenConfiguration
import com.plaid.link.result.LinkResultHandler

class MainActivity : FlutterActivity() {
    private val channel = "plaidChannel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler { call, result ->
            if (call.method == "openPlaidLink") {
                val linkToken = call.argument<String>("linkToken")
                Toast.makeText(context, "Public Token: ${linkToken}", Toast.LENGTH_LONG).show()
               linkToken?.let {
                   openPlaidLink(context, it)
                   result.success(null)
               } ?: run {
                   result.error("NO_TOKEN", "No Link token provided", null)
               }
            } else {
                result.notImplemented()
            }
        }
    }
   private fun openPlaidLink(context: Context, linkToken: String) {
       val configuration = LinkTokenConfiguration.Builder()
               .token(linkToken)
               .build()

       val resultHandler = LinkResultHandler(
               onSuccess = { publicTokenResult ->
                   // Handle success, send public token to your server
                   Toast.makeText(context, "Public Token: ${publicTokenResult.publicToken}", Toast.LENGTH_LONG).show()
               },
               onExit = { exitResult ->
                   // Handle exit (user cancellation, failure, etc.)
                   Toast.makeText(context, "Exit: ${exitResult.error?.displayMessage}", Toast.LENGTH_LONG).show()

               }
       )

       Plaid.create(
               application,// Pass the Activity here
               linkTokenConfiguration = configuration
       ).open(activity)
   }
}
