import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/views/main/home/home_controller.dart';
import 'package:paclub/frontend/views/main/home/home_follow/home_follow_page.dart';
import 'package:paclub/frontend/views/main/home/home_hot/home_hot_page.dart';
import 'package:paclub/frontend/views/main/app_controller.dart';
import 'package:paclub/frontend/widgets/buttons/scale_floating_action_button.dart';

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
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                actions: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.search,
                        size: 28.0,
                      ),
                      onPressed: () {
                        print('点击了搜索按钮');
                      }),
                ],
                pinned: true,
                floating: true,
                // flexibleSpace: Placeholder(),
                forceElevated: true,
                elevation: 1.0,
                title: Text(
                  'Paclub',
                  style: TextStyle(fontSize: 24.0, color: accentColor),
                ),
                bottom: TabBar(
                  overlayColor: MaterialStateProperty.resolveWith(
                    (states) {
                      return Colors.transparent;
                    },
                  ),
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: [
                    Tab(
                      child: Text(
                        '熱門',
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Tab(
                      child: Text(
                        '追蹤',
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              )
            ];
          },
          body: GetBuilder<AppController>(
            builder: (_) {
              return TabBarView(
                dragStartBehavior: DragStartBehavior.down,
                children: <Widget>[
                  HomeHotPage(),
                  HomeFollowPage(),
                ],
              );
            },
          ),
        ),
        floatingActionButton: ScaleFloatingActionButton(
          onPressed: () {
            controller.navigateToPostPage();
          },
          child: Icon(
            Icons.post_add,
            color: Colors.white,
            size: 32.0,
          ),
        ),
      ),
    );
  }
}
