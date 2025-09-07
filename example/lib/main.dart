import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:linkhive_flutter/linkhive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LinkHiveClient.instance.connect(
    baseUrl: 'YOUR_BASE_URL_HERE', // Replace with your SaaS base URL
    projectId: 'YOUR_PROJECT_ID_HERE', // Replace with your project ID
    clientId: 'YOUR_CLIENT_ID_HERE', // Replace with your client ID
  );
  LinkHiveClient.instance.dynamicLinks.create(request)
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('LinkHive Plugin example app')),
      ),
    );
  }
}
