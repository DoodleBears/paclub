import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:paclub/frontend/views/auth/login/components/rounded_input_field.dart';
import 'package:paclub/frontend/views/auth/register/form/register_form_controller.dart';
import 'package:paclub/frontend/widgets/containers/fade_in_scale_container.dart';
import 'package:paclub/utils/logger.dart';

class RegisterForm2 extends GetView<RegisterFormController> {
  const RegisterForm2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterFormController>(
      assignId: true,
      id: 'form_2',
      builder: (_) {
        logger.w('重新渲染 form_2');
        return FadeInScaleContainer(
          width: Get.width * 0.8,
          height: controller.page == 2 ? 16 + Get.height * 0.18 : 0.0,
          isShow: controller.page == 2,
          child: RoundedInputField(
            counterText: null,
            textInputType: TextInputType.multiline,
            height: 16 + Get.height * 0.17,
            maxLines: 6,
            maxLength: 400,
            labelText: 'Bio',
            onChanged: controller.onBioChanged,
          ),
        );
      },
    );
  }
}
