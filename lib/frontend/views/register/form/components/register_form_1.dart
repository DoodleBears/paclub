import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/views/login/components/rounded_input_field.dart';
import 'package:paclub/frontend/views/register/form/register_form_controller.dart';
import 'package:paclub/frontend/widgets/containers/fade_in_scale_container.dart';
import 'package:paclub/utils/logger.dart';

class RegisterForm1 extends GetView<RegisterFormController> {
  const RegisterForm1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        logger.w('重新渲染 form_1');
        return FadeInScaleContainer(
          width: Get.width * 0.8,
          height: controller.page.value != 1 ? 0.0 : 16 + Get.height * 0.07,
          isShow: controller.page.value == 1,
          child: RoundedInputField(
            textInputType: TextInputType.name,
            error: controller.isNameOK.value == false,
            hintText: 'Name',
            icon: Icon(
              Icons.person,
              color: accentColor,
            ),
            onChanged: controller.onNameChanged,
          ),
        );
      },
    );
  }
}
