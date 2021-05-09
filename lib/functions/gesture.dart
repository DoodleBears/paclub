import 'package:flutter/widgets.dart';
import 'package:paclub/widgets/logger.dart';

void hideKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus.unfocus();
    logger.d('隐藏键盘 Keyboard');
  }
}
