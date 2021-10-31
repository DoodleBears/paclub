import 'package:flutter/material.dart';

class MultiLineTags extends StatelessWidget {
  const MultiLineTags({
    Key? key,
    required this.tags,
    required this.onDeleted,
    this.backgroundColor,
  }) : super(key: key);
  final List<String> tags;
  final Color? backgroundColor;
  final Function(String) onDeleted;
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4.0,
      runSpacing: -8.0,
      children: tags.map(
        (String tag) {
          return RawChip(
            backgroundColor: backgroundColor,
            deleteIcon: Icon(Icons.close_rounded),
            onDeleted: () {
              onDeleted(tag);
            },
            label: Text(tag),
          );
        },
      ).toList(),
    );
  }
}
