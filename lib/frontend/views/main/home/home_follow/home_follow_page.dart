import 'package:flutter/material.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/constants/constants.dart';

class HomeFollowPage extends StatelessWidget {
  const HomeFollowPage({Key? key}) : super(key: key);

  Future<Null> getRefresh() async {
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: getRefresh,
      backgroundColor: accentColor,
      color: AppColors.refreshIndicatorColor,
      child: Container(
        color: AppColors.homeListViewBackgroundColor,
        child: ListView.builder(
          padding: EdgeInsets.zero,
          physics: BouncingScrollPhysics(),
          itemCount: 40,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                print('点击了 $index');
              },
              child: Card(
                margin: EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius)),
                // clipBehavior: Clip.antiAlias,
                elevation: 1.0,
                child: Container(
                  height: index % 2 == 0 ? 200 : null,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(20),
                  child: ListTile(
                    title: Text(
                      'Paclub Follow $index',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
              ),
            );
          },
        ),
      ),
    );
  }
}
