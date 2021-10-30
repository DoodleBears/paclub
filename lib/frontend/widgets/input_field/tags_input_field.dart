import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/utils/length_limit_textfield_formatter.dart';

class TagsInputField extends StatelessWidget {
  const TagsInputField({
    Key? key,
    required this.titleText,
    required this.tags,
    required this.onChanged,
    required this.onDeleteChip,
    required this.onTap,
    this.inputFormatters,
    this.controller,
    this.barColor,
    this.maxLines,
    this.error = false,
    this.errorText,
  }) : super(key: key);
  final ValueChanged<String> onChanged;
  final VoidCallback onTap;
  final Function(String) onDeleteChip;
  final List<String> tags;
  final String titleText;
  final int? maxLines;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final Color? barColor;
  final bool error;
  final String? errorText;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            titleText,
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),
        Wrap(
          spacing: 4.0,
          runSpacing: -8.0,
          children: tags.map(
            (String tag) {
              return Chip(
                onDeleted: () {
                  onDeleteChip(tag);
                },
                label: Text(tag),
              );
            },
          ).toList(),
        ),
        TextField(
          controller: controller,
          onChanged: onChanged,
          maxLines: maxLines,
          keyboardType: TextInputType.text,
          inputFormatters: inputFormatters ??
              [
                LengthLimitingTextFieldFormatterFixed(128),
              ],
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            suffixIconConstraints: BoxConstraints.tight(Size(32.0, 32.0)),
            suffixIcon: GestureDetector(
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.circleButtonBackgoundColor,
                ),
                child: Icon(
                  Icons.add,
                  color: AppColors.normalTextColor,
                ),
              ),
            ),
            hintText: 'Add',
            border: InputBorder.none,
            errorText: error ? errorText : null,
          ),
        )
      ],
    );
  }
}
