import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paclub/frontend/utils/length_limit_textfield_formatter.dart';

class SimpleInputField extends StatelessWidget {
  const SimpleInputField({
    Key? key,
    required this.titleText,
    this.controller,
    this.barColor,
    this.maxLines,
    this.inputFormatters,
  }) : super(key: key);
  final String titleText;
  final int? maxLines;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final Color? barColor;
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: 8.0,
              right: 8.0,
            ),
            child: Container(
              width: 6.0,
              decoration: ShapeDecoration(
                shape: StadiumBorder(),
                color: barColor ?? Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                TextField(
                  controller: controller,
                  minLines: 1,
                  maxLines: maxLines,
                  inputFormatters: inputFormatters ??
                      [
                        LengthLimitingTextFieldFormatterFixed(128),
                      ],
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Add',
                    border: InputBorder.none,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
