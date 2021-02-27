import 'package:flutter/material.dart';
import 'tabs/Home.dart';
import 'tabs/Card.dart';
import 'tabs/Message.dart';
import 'tabs/Notification.dart';
import 'tabs/User.dart';

class Tabs extends StatefulWidget {
  Tabs({Key key}) : super(key: key);

  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _currentIndex = 0;

  List _pageList = [
    HomePage(),
    CardPage(),
    MessagePage(),
    NotificationPage(),
    UserPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: this._pageList[this._currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: this._currentIndex,
        onTap: (int index) {
          setState(() {
            this._currentIndex = index;
          });
        },
        showSelectedLabels: true,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "首頁"),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb), label: "抽卡"),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "私訊"),
          BottomNavigationBarItem(icon: Icon(Icons.alarm), label: "提醒"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "個人")
        ],
      ),
    );
  }
}
