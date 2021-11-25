import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'view/bottomNavigation.dart';
import 'controller/notificationService.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) {
        var t = AppLocalizations.of(context);
        if (t == null) {
          return "Error";
        } else {
          return t.appTitle;
        }
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) {
          String title;
          var t = AppLocalizations.of(context);
          if (t == null) {
            title = "Matheus";
          } else {
            title = t.appTitle;
          }
          print(title);
          return BottomNavigation(title: title);
        }
      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
