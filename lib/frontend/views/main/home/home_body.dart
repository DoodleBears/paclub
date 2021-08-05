import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/views/main/home/home_controller.dart';
import 'package:paclub/frontend/views/main/home/home_follow/home_follow_page.dart';
import 'package:paclub/frontend/views/main/home/home_hot/home_hot_page.dart';

class HomeBody extends GetView<HomeController> {
  const HomeBody({Key? key}) : super(key: key);

  Future<Null> getRefresh() async {
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search), onPressed: () {}),
          ],
          title: Text('盒群'),
          bottom: TabBar(
            tabs: <Widget>[Tab(text: '熱門'), Tab(text: '追蹤')],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            HomeHotPage(),
            HomeFollowPage(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {controller.signOut()},
          child: Icon(Icons.exit_to_app),
        ),
      ),
    );
  }
}
