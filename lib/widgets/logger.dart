import 'package:logger/logger.dart';

var logger3 = Logger(
  printer: PrettyPrinter(
    colors: true,
    lineLength: 150,
    printEmojis: true,
    methodCount: 3,
    // printTime: true,
  ),
);
var logger = Logger(
  printer: PrettyPrinter(
    colors: true,
    lineLength: 150,
    printEmojis: true,
    methodCount: 1,
    // printTime: true,
  ),
);
var loggerNoStack = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
  ),
);
