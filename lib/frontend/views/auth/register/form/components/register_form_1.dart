import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/views/auth/login/components/rounded_input_field.dart';
import 'package:paclub/frontend/views/auth/register/form/register_form_controller.dart';
import 'package:paclub/frontend/widgets/containers/fade_in_scale_container.dart';
import 'package:paclub/utils/logger.dart';

class RegisterForm1 extends GetView<RegisterFormController> {
  const RegisterForm1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterFormController>(
      assignId: true,
      id: 'form_1',
      builder: (_) {
        logger.w('重新渲染 form_1');
        return FadeInScaleContainer(
          width: Get.width * 0.8,
          height: controller.page == 1 ? 16 + Get.height * 0.08 : 0.0,
          isShow: controller.page == 1,
          child: RoundedInputField(
            counterText: '${controller.name.length}/50',
            textInputType: TextInputType.name,
            error: controller.isNameOK == false,
            errorText: controller.errorText,
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
