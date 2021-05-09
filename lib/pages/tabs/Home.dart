import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/services/auth_service.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Null> getRefresh() async {
    await Future.delayed(Duration(seconds: 2));
  }

  final AuthService authService = Get.find<AuthService>();

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
            RefreshIndicator(
              onRefresh: getRefresh,
              backgroundColor: Colors.blue,
              color: Colors.black,
              child: ListView.builder(
                itemCount: 500,
                itemBuilder: (context, index) {
                  return Container(
                    child: Container(
                      color: Colors.white,
                      child: Card(
                        color: Colors.pink[100],
                        margin: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        clipBehavior: Clip.antiAlias,
                        elevation: 10,
                        child: Container(
                            height: 200,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(20),
                            child: ListTile(
                              title: Text(
                                'Paclub Number $index',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                'Little Subtitle Test $index and $index',
                                maxLines: 1, //最多顯示行數
                                overflow:
                                    TextOverflow.ellipsis, //以...顯示沒顯示的文字,,
                                style: TextStyle(fontSize: 15),
                              ),
                              leading: Icon(
                                Icons.account_box,
                                size: 40,
                                color: Colors.blue,
                              ),
                              trailing: Icon(
                                Icons.chevron_right,
                                size: 40,
                              ),
                            )),
                      ),
                    ),
                  );
                },
              ),
            ),
            RefreshIndicator(
              onRefresh: getRefresh,
              backgroundColor: Colors.blue,
              color: Colors.black,
              child: ListView.builder(
                itemCount: 500,
                itemBuilder: (context, index) {
                  return Container(
                    child: Container(
                      color: Colors.white,
                      child: Card(
                        color: Colors.orange[100],
                        margin: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        clipBehavior: Clip.antiAlias,
                        elevation: 10,
                        child: Container(
                            height: 200,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(20),
                            child: ListTile(
                              title: Text(
                                'Paclub Number $index',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                'Little Subtitle Test $index and $index',
                                maxLines: 1, //最多顯示行數
                                overflow:
                                    TextOverflow.ellipsis, //以...顯示沒顯示的文字,,
                                style: TextStyle(fontSize: 15),
                              ),
                              leading: Icon(
                                Icons.account_box,
                                size: 40,
                                color: Colors.blue,
                              ),
                              trailing: Icon(
                                Icons.chevron_right,
                                size: 40,
                              ),
                            )),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () => _OnFabClick,
              child: Icon(Icons.add),
            ),
            const SizedBox(height: 10.0),
            FloatingActionButton(
              onPressed: () => {authService.signOut()},
              child: Icon(Icons.exit_to_app),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnFabClick {}
