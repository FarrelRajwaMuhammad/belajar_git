import 'package:flutter/material.dart';
import 'widget/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Simpel Gw',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(), 
    );
  }
}

