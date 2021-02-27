import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  UserPage({Key key}) : super(key: key);

  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text("I"),
        ),
        ListTile(
          title: Text("II"),
        ),
        ListTile(
          title: Text("III"),
        ),
        ListTile(
          title: Text("IV"),
        ),
        ListTile(
          title: Text("V"),
        ),
        ListTile(
          title: Text("VI"),
        ),
        ListTile(
          title: Text("VII"),
        ),
        ListTile(
          title: Text("VIII"),
        ),
        ListTile(
          title: Text("IX"),
        ),
        ListTile(
          title: Text("X"),
        )
      ],
    );
  }
}
