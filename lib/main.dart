import 'package:flutter/material.dart';
import 'package:moustache_ar/screens/views/moustache_ar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AddMoustacheScreen(),
    );
  }
}

// https://pub.dev/publishers/flutter-ml.dev/packages