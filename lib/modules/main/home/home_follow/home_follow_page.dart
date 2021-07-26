import 'package:flutter/material.dart';

class HomeFollowPage extends StatelessWidget {
  const HomeFollowPage({Key? key}) : super(key: key);

  Future<Null> getRefresh() async {
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: getRefresh,
      backgroundColor: Colors.blue,
      color: Colors.black,
      child: ListView.builder(
        itemCount: 100,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.orange[100],
            margin: EdgeInsets.all(15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            clipBehavior: Clip.antiAlias,
            elevation: 10,
            child: Container(
              height: 200,
              alignment: Alignment.center,
              padding: EdgeInsets.all(20),
              child: ListTile(
                title: Text(
                  'Paclub Number $index',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Little Subtitle Test $index and $index',
                  maxLines: 1, //最多顯示行數
                  overflow: TextOverflow.ellipsis, //以...顯示沒顯示的文字,,
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
              ),
            ),
          );
        },
      ),
    );
  }
}
