import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:paclub/frontend/constants/colors.dart';

class CircleAvatarContainer extends StatelessWidget {
  const CircleAvatarContainer({
    Key? key,
    required this.avatarUrl,
    required this.width,
    required this.height,
    this.isBorderShow = false,
  }) : super(key: key);
  final String avatarUrl;
  final double width;
  final double height;
  final bool isBorderShow;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: AppColors.profileAvatarBackgroundColor,
        child: avatarUrl == ''
            ? Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: isBorderShow
                      ? Border.all(
                          color: AppColors.profileAvatarBorderColor!,
                          width: 1.5,
                        )
                      : null,
                ),
              )
            : Ink.image(
                image: CachedNetworkImageProvider(avatarUrl),
                fit: BoxFit.cover,
                width: width,
                height: height,
                child: InkWell(
                  onTap: () async {},
                ),
              ),
      ),
    );
  }
}
