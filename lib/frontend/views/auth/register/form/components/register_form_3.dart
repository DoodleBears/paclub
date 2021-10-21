import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/views/auth/register/form/register_form_controller.dart';
import 'package:paclub/frontend/views/main/app_controller.dart';
import 'package:paclub/frontend/widgets/containers/fade_in_scale_container.dart';
import 'package:paclub/utils/logger.dart';

class RegisterForm3 extends GetView<RegisterFormController> {
  const RegisterForm3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      builder: (_) {
        return GetBuilder<RegisterFormController>(
          assignId: true,
          id: 'form_3',
          builder: (_) {
            logger.w('重新渲染 form_3');
            return FadeInScaleContainer(
              width: Get.width * 0.8,
              height: controller.page == 3 ? 16 + Get.height * 0.20 : 0.0,
              isShow: controller.page == 3,
              padding: EdgeInsets.only(bottom: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: accentColor,
                    width: 1.5,
                  ),
                ),
                child: CircleAvatar(
                  backgroundColor: AppColors.avatarBackgroundColor,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
