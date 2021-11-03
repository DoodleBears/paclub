import 'package:flutter/material.dart';
import 'package:paclub/frontend/constants/colors.dart';

class TagsBlock extends StatelessWidget {
  const TagsBlock({
    Key? key,
    required this.tags,
    required this.tagsNumber,
    this.alignment = WrapAlignment.start,
  }) : super(key: key);

  final List<String> tags;
  final int tagsNumber;
  final WrapAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: -2.0,
      runSpacing: -4.0,
      alignment: alignment,
      children: tags.getRange(0, tagsNumber).map(
        (tag) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: RawChip(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              visualDensity: VisualDensity(
                horizontal: VisualDensity.minimumDensity,
                vertical: VisualDensity.minimumDensity,
              ),
              padding: EdgeInsets.zero,
              backgroundColor: primaryColor,
              labelStyle: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
              ),
              label: Text(tag),
            ),
          );
        },
      ).toList(),
    );
  }
}
