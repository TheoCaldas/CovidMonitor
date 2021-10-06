import 'package:flutter/material.dart';
import 'view/bottomNavigation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Covid Monitor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BottomNavigation(title: 'Monitor Brasileiro de COVID-19'),
    );
  }
}
