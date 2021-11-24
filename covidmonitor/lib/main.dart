import 'package:flutter/material.dart';
import 'view/bottomNavigation.dart';
import 'controller/notificationService.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
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
