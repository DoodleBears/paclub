// TODO 常用的 Text的样式
import 'package:flutter/material.dart';
import 'package:paclub/helper/constants.dart';

Text contentText(String text) {
  return Text(
    text,
    style: TextStyle(color: Colors.white, fontSize: Constants.textSize),
  );
}
