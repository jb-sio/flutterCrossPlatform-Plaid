// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  requestPermissions().then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plaid Integration Example')),
        body: const Center(
          child: PlaidButton(),
        ),
      ),
    );
  }
}

class PlaidButton extends StatelessWidget {
  static const platform = MethodChannel('plaidChannel');

  const PlaidButton({super.key});

  Future<void> _openPlaidLink() async {
    try {
      await platform.invokeMethod('openPlaidLink',
          {'linkToken': 'link-sandbox-ee5abb60-8c31-47ef-9e69-856fa129a01e'});
    } on PlatformException catch (e) {
      print("Failed to open Plaid Link: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _openPlaidLink,
      child: const Text('Open Plaid Link'),
    );
  }
}
