import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/service_locator.dart';
import 'router.dart';

void main() {
  setupServiceLocator(); // Init GetIt
  runApp(const ProviderScope(child: MyApp())); // Init Riverpod
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'OpenGIF',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      debugShowCheckedModeBanner: false,
    );
  }
}
