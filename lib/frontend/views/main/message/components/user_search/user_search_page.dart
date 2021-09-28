import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/views/main/message/components/user_search/user_search_body.dart';
import 'package:paclub/utils/logger.dart';
import 'package:flutter/material.dart';

class UserSearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    logger.d('渲染 UserSearchPage');
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: accentColor,
        title: Text(
          '搜索好友',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: UserSearchBody(),
    );
  }
}
