import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/views/main/app_controller.dart';
import 'package:paclub/frontend/widgets/avatar/circle_avatar_container.dart';

class MultiAvatarContainer extends StatelessWidget {
  const MultiAvatarContainer({
    Key? key,
    required this.avatarsUrl,
    required this.width,
    required this.height,
    this.isBorderShow = false,
    this.offset = 30.0,
  }) : super(key: key);
  final List<String> avatarsUrl;
  final double width;
  final double height;
  final double offset;
  final bool isBorderShow;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: GetBuilder<AppController>(
        builder: (_) {
          return Stack(
            children: [
              Positioned(
                width: width,
                left: 0,
                child: CircleAvatarContainer(
                  avatarUrl: avatarsUrl[0],
                  isBorderShow: true,
                  width: width,
                  height: height,
                ),
              ),
              Positioned(
                width: width,
                left: offset * 1,
                child: CircleAvatarContainer(
                  isBorderShow: true,
                  avatarUrl: avatarsUrl[1],
                  width: width,
                  height: height,
                ),
              ),
              avatarsUrl.length > 2
                  ? Positioned(
                      width: width,
                      left: offset * 2,
                      child: Container(
                        width: width,
                        height: height,
                        decoration: BoxDecoration(
                          color: AppColors.profileAvatarBackgroundColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.profileAvatarBorderColor!,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${avatarsUrl.length - 2}',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }
}
