import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/constants/constants.dart';
import 'package:paclub/frontend/views/main/home/home_follow/home_follow_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeFollowPage extends GetView<HomeFollowController> {
  const HomeFollowPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      controller: controller.refreshController,
      onLoading: controller.loadMorePack,
      header: ClassicHeader(
        completeIcon: SizedBox.shrink(),
        completeText: '',
      ),
      footer: ClassicFooter(
        textStyle: TextStyle(
          fontSize: 18.0,
        ),
        loadingText: '',
        spacing: 0.0,
        loadingIcon: SizedBox(
          height: 28.0,
          width: 28.0,
          child: CircularProgressIndicator(
            color: accentColor,
            strokeWidth: 6.0,
            // color: AppColors.refreshIndicatorColor,
          ),
        ),
        loadStyle: LoadStyle.ShowWhenLoading,
        height: 60.0,
      ),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
              // clipBehavior: Clip.antiAlias,
              elevation: 1.0,
              child: Container(
                height: index % 2 == 0 ? 200 : null,
                alignment: Alignment.center,
                padding: EdgeInsets.all(20),
                child: ListTile(
                  title: Text(
                    'Paclub Follow $index',
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
            ),
          );
        },
      ),
    );
  }
}
