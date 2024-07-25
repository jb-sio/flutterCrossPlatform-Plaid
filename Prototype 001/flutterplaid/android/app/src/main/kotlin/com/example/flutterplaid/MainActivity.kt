package com.example.flutterplaid

import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val channelName = "customeplaidlink"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        var channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger,channelName);

        channel.setMethodCallHandler { call, result ->

            val linkTokenConfiguration = linkTokenConfiguration {
                token = "public-sandbox-e043851f-a3e1-4374-ad1d-b4c9f6323a84"
                }
        }
    }
}
