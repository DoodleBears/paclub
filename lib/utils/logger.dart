import 'package:logger/logger.dart';

var logger3 = Logger(
  printer: PrettyPrinter(
    colors: true,
    lineLength: 80,
    printEmojis: true,
    methodCount: 3,
    // printTime: true,
  ),
);
var logger = Logger(
  printer: PrettyPrinter(
    colors: true,
    lineLength: 80,
    printEmojis: true,
    methodCount: 1,
    // printTime: true,
  ),
);
var logger0 = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    lineLength: 80,
    printEmojis: true,
  ),
);
