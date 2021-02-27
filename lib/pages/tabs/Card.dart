import 'package:flutter/material.dart';

class CardPage extends StatefulWidget {
  CardPage({Key key}) : super(key: key);

  _CardPageState createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text("1"),
        ),
        ListTile(
          title: Text("2"),
        ),
        ListTile(
          title: Text("3"),
        ),
        ListTile(
          title: Text("4"),
        ),
        ListTile(
          title: Text("5"),
        ),
        ListTile(
          title: Text("6"),
        ),
        ListTile(
          title: Text("7"),
        ),
        ListTile(
          title: Text("8"),
        ),
        ListTile(
          title: Text("9"),
        ),
        ListTile(
          title: Text("10"),
        )
      ],
    );
  }
}
