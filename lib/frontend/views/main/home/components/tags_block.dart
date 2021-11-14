import 'package:flutter/material.dart';
import 'package:paclub/frontend/constants/colors.dart';

class TagsBlock extends StatelessWidget {
  const TagsBlock({
    Key? key,
    required this.tags,
    required this.tagsNumber,
    this.alignment = WrapAlignment.start,
    this.fontSize = 12.0,
    this.spacing = -2.0,
    this.runSpacing = -4.0,
    this.runAlignment = WrapAlignment.start,
  }) : super(key: key);

  final List<String> tags;
  final int tagsNumber;
  final WrapAlignment alignment;
  final WrapAlignment runAlignment;
  final double fontSize;
  final double spacing;
  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      alignment: alignment,
      runAlignment: runAlignment,
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
                vertical: -1.0,
              ),
              padding: EdgeInsets.zero,
              backgroundColor: primaryColor,
              labelStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
              ),
              label: Text(
                tag,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
