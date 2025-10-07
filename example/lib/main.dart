import 'package:flutter/material.dart';
import 'package:linkhive_flutter/linkhive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LinkHiveClient.instance.connect(
    baseUrl: 'base url',
    projectId: 'your projectId',
    clientId: 'your clientId',
  );

  print(LinkHiveClient.instance.isConnected);
  var deferred = await LinkHiveClient.instance.dynamicLinks.getDeferredLink();
  print(deferred);
  var initial = await LinkHiveClient.instance.dynamicLinks.getInitialLink();
  print('initial  $initial');
  LinkHiveClient.instance.dynamicLinks.onLinkReceived.listen((e) {
    print('link clicked  $e');
  });
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
