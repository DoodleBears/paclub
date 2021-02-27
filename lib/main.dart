import 'package:flutter/material.dart';
import 'pages/Tabs.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Welcome to 盒群",
        home: Tabs());
  }
}
