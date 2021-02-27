import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

//TODO: Add write and post function on FabClick
class onFabClick {}

// initial build
class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: buildAppBar(),
        body: buildTabBarView(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => onFabClick,
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  // Content
  TabBarView buildTabBarView() {
    return TabBarView(
      children: <Widget>[
        ListView(
          children: <Widget>[
            ListTile(
              title: Text("我是一隻狗"),
            ),
            ListTile(
              title: Text("我是一隻狗"),
            ),
            ListTile(
              title: Text("我是一隻狗"),
            )
          ],
        ),
        ListView(
          children: <Widget>[
            ListTile(
              title: Text("我是一隻貓"),
            ),
            ListTile(
              title: Text("我是一隻貓"),
            ),
            ListTile(
              title: Text("我是一隻貓"),
            )
          ],
        ),
      ],
    );
  }

  // AppBar Top Bar
  AppBar buildAppBar() {
    return AppBar(
      title: Text("盒群"),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.search), onPressed: () {}),
      ],
      bottom: TabBar(
        tabs: <Widget>[Tab(text: "熱門"), Tab(text: "追蹤")],
      ),
    );
  }
}
