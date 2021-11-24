import 'package:covidmonitor/view/vaccination.dart';
import 'package:flutter/material.dart';
import 'package:covidmonitor/view/statisticsPage.dart';
import 'package:covidmonitor/view/profilePage.dart';
import 'package:covidmonitor/model/constants.dart';

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
              label: 'Estatísticas',
              backgroundColor: Constants.backgroundColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.medical_services),
              label: 'Acompanhamento',
              backgroundColor: Constants.backgroundColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Perfil',
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
