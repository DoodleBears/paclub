import 'package:flutter/material.dart';
import 'package:paclub/constants/constants.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          _buildDivider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text('OR',
                style: TextStyle(
                    color: primaryDarkColor, fontWeight: FontWeight.w600)),
          ),
          _buildDivider(),
        ],
      ),
    );
  }

  Widget _buildDivider() => Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Divider(
            color: Color(0xFFD9D9D9),
            height: 1.5,
          ),
        ),
      );
}
