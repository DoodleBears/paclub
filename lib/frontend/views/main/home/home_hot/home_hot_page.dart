import 'package:flutter/material.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/constants/numbers.dart';

class HomeHotPage extends StatelessWidget {
  const HomeHotPage({Key? key}) : super(key: key);

  Future<Null> getRefresh() async {
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: getRefresh,
      backgroundColor: accentColor,
      color: Colors.white,
      child: Container(
        color: AppColors.listViewBackgroundColor,
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
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
                elevation: 1.0,
                child: Container(
                  height: index % 2 == 0 ? 200 : null,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: ListTile(
                    title: Text(
                      'Paclub Hot $index',
                      style: Theme.of(context).textTheme.headline1!.copyWith(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
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
