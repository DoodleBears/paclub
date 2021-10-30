import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:paclub/frontend/constants/constants.dart';

class AvatarsInputField extends StatelessWidget {
  const AvatarsInputField({
    Key? key,
    required this.titleText,
    required this.avatarsUrl,
  }) : super(key: key);
  final String titleText;
  final List<String> avatarsUrl;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            titleText,
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: avatarsUrl.length,
              itemBuilder: (context, index) {
                return ClipOval(
                  child: Material(
                    color: AppColors.profileAvatarBackgroundColor,
                    child: avatarsUrl[index] == ''
                        ? Container(
                            width: 48,
                            height: 48,
                          )
                        : Ink.image(
                            image:
                                CachedNetworkImageProvider(avatarsUrl[index]),
                            fit: BoxFit.cover,
                            width: 48,
                            height: 48,
                            child: InkWell(
                              onTap: () async {},
                            ),
                          ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
