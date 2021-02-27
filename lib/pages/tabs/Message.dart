import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  MessagePage({Key key}) : super(key: key);

  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text("a"),
        ),
        ListTile(
          title: Text("b"),
        ),
        ListTile(
          title: Text("c"),
        ),
        ListTile(
          title: Text("d"),
        ),
        ListTile(
          title: Text("e"),
        ),
        ListTile(
          title: Text("f"),
        ),
        ListTile(
          title: Text("g"),
        ),
        ListTile(
          title: Text("h"),
        ),
        ListTile(
          title: Text("i"),
        ),
        ListTile(
          title: Text("j"),
        )
      ],
    );
  }
}
