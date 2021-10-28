import 'package:flutter/material.dart';
import 'package:paclub/frontend/constants/colors.dart';

class DragHandler extends StatelessWidget {
  const DragHandler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Center(
        child: Container(
          decoration: ShapeDecoration(
            shape: StadiumBorder(),
            color: AppColors.bottomSheetHandlerColor,
          ),
          height: 6.0,
          width: 40.0,
        ),
      ),
    );
  }
}
