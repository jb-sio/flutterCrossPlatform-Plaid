// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

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
          {'linkToken': 'public-sandbox-0b88618b-cd99-48ea-ad08-538bf370172c'});
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
