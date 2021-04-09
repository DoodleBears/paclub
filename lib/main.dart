import 'package:flutter/material.dart';
import 'pages/Tabs.dart';
import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    logger.d(
        'Click here to checkout more Logger utility https://pub.dev/packages/logger/example');
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Welcome to 盒群",
        home: Tabs());
  }
}
