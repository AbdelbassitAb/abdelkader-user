import 'package:abdelkader_user/constants/color.dart';
import 'package:abdelkader_user/screens/home.dart';
import 'package:abdelkader_user/screens/workers.dart';
import 'package:flutter/material.dart';

class SwitchPage extends StatefulWidget {
  @override
  _SwitchPageState createState() => _SwitchPageState();
}

class _SwitchPageState extends State<SwitchPage> {
  int _selectedindex;

  @override
  void initState() {
    _selectedindex = 0;
    super.initState();
  }

  static List<Widget> _widgetOptions = <Widget>[
    Home(),
    Workers(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Center(
            child: _widgetOptions.elementAt(_selectedindex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: _selectedindex == 0 ? primaryColor : Colors.grey,
                ),
                title: Text(
                  'Page principale',
                  style: TextStyle(
                    color: _selectedindex == 0 ? primaryColor : Colors.grey,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.groups,
                  color: _selectedindex == 1 ? primaryColor : Colors.grey,
                ),
                title: Text(
                  'Travailleurs',
                  style: TextStyle(
                    color: _selectedindex == 1 ? primaryColor : Colors.grey,
                  ),
                ),
              )
            ],
            currentIndex: _selectedindex,
            onTap: (value) {
              setState(() {
                _selectedindex = value;
              });
            },
            type: BottomNavigationBarType.shifting,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.black,
            showUnselectedLabels: true,
          )),
    );
  }
}
