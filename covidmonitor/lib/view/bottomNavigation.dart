import 'package:covidmonitor/view/vaccination.dart';
import 'package:flutter/material.dart';
import 'package:covidmonitor/view/statisticsPage.dart';
import 'package:covidmonitor/view/profilePage.dart';
import 'package:covidmonitor/model/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BottomNavigation extends StatefulWidget {
  BottomNavigation({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    StatisticsPage(),
    Vacination(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Constants.backgroundColor,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.coronavirus),
              label: t!.btmBarStats,
              backgroundColor: Constants.backgroundColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.medical_services),
              label: t!.btmBarAc,
              backgroundColor: Constants.backgroundColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: t!.btmBarProfile,
              backgroundColor: Constants.backgroundColor,
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Constants.primaryColor,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.shifting),
    );
  }
}
