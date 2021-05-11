import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:paclub/constants/constants.dart';
import 'package:paclub/r.dart';
import 'package:paclub/routes/app_pages.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: double.infinity,
        alignment: Alignment.center,
        padding: EdgeInsets.only(
          top: Get.width * 0.01,
          bottom: Get.width * 0.08,
          left: Get.width * 0.07,
          right: Get.width * 0.07,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                R.appIcon, //使用Class调用内置图片地址
                height: Get.width * 0.1,
                fit: BoxFit.fitHeight,
              ),
            ),
            const Expanded(child: SizedBox()),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '合群，和而不同。',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: Get.width * 0.07,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: context.height * 0.02),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(borderRadius)),
                      primary: accentColor,
                      padding: EdgeInsets.symmetric(
                          vertical: context.height * 0.008),
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: () => Get.toNamed(Routes.REGISTER),
                    child: Text(
                      '创建账号',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: Get.width * 0.06,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Expanded(child: SizedBox()),
            Row(
              children: [
                Text(
                  '已经有账号了? ',
                  style: TextStyle(
                    fontSize: Get.width * 0.036,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.toNamed(Routes.LOGIN),
                  child: Text(
                    '登录',
                    style: TextStyle(
                      fontSize: Get.width * 0.036,
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
