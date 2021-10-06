import 'package:covidmonitor/homePage.dart';
import 'package:covidmonitor/profilePage.dart';
import 'package:flutter/material.dart';
import 'constants.dart';

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
      home: Navigation(title: 'Monitor Brasileiro de COVID-19'),
    );
  }
}

class Navigation extends StatefulWidget {
  Navigation({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    MyHomePage(),
    Text(
      'Dados pessoais',
      style: optionStyle,
    ),
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
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
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
