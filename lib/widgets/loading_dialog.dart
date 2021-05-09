import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/modules/login/components/login_components.dart';
import 'package:paclub/modules/login/login_controller.dart';

class LoadingDialog extends GetView<LoginController> {
  const LoadingDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        key: key,
        backgroundColor: Colors.white,
        content: Row(
          children: <Widget>[
            Center(
              child: GetBuilder<LoginController>(
                builder: (controller) {
                  return RoundedPasswordField(
                    onChanged: controller.onPasswordChanged,
                    hidePassword: controller.hidePassword,
                  );
                },
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('SUBMIT'),
          ),
        ],
      ),
    );
  }
}
