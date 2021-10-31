import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:paclub/frontend/constants/colors.dart';

class PackTile extends StatelessWidget {
  const PackTile({
    Key? key,
    this.color,
    required this.packName,
    required this.pid,
    required this.photoURL,
    this.onChanged,
    this.value,
  }) : super(key: key);

  final bool? value;
  final Color? color;
  final String packName;
  final String pid;
  final String photoURL;
  final Function(bool?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: value == true ? color : null,
      child: CheckboxListTile(
        tileColor: accentColor,
        selectedTileColor: accentColor,
        title: Text(
          packName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        subtitle: Text(
          pid,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14.0,
            color: AppColors.normalGrey,
          ),
        ),
        activeColor: accentColor,
        secondary: Material(
          borderRadius: BorderRadius.circular(8.0),
          clipBehavior: Clip.antiAlias,
          child: photoURL == ''
              ? Container(
                  width: 48.0,
                  height: 48.0,
                  child: Center(
                    child: Text(
                      packName.substring(0, 1).toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              : Ink.image(
                  image: CachedNetworkImageProvider(photoURL),
                  fit: BoxFit.cover,
                  width: 48.0,
                  height: 48.0,
                ),
        ),
        onChanged: onChanged,
        value: value,
      ),
    );
  }
}
