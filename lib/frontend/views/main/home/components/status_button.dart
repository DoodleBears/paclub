import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paclub/frontend/constants/colors.dart';

class StatusButton extends StatefulWidget {
  const StatusButton({
    Key? key,
    required this.icon,
    required this.number,
    required this.iconClicked,
  }) : super(key: key);

  final Widget icon;
  final Widget iconClicked;
  final int number;

  @override
  State<StatusButton> createState() => _StatusButtonState();
}

class _StatusButtonState extends State<StatusButton> {
  bool clicked = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: ElevatedButton.icon(
        onPressed: () {
          // print('press');
          HapticFeedback.lightImpact();
          setState(() {
            clicked = !clicked;
          });
        },
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          padding: MaterialStateProperty.all(EdgeInsets.all(8.0)),
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
        ),
        icon: clicked ? widget.iconClicked : widget.icon,
        label: Text(
          '${widget.number + (clicked ? 1 : 0)}',
          style: TextStyle(
            color: AppColors.normalTextColor,
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
