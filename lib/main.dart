import 'package:box_group/models/NotesOperation.dart';
import 'package:flutter/material.dart';
import 'pages/Tabs.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NotesOperation>(
      create: (context) => NotesOperation(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Welcome to 盒群",
          home: Tabs()),
    );
  }
}
