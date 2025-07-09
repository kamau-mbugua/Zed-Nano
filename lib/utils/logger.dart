import 'package:logger/logger.dart';

final Logger logger = Logger(
  printer: PrettyPrinter(lineLength: 10000),
);

final Logger loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0,lineLength: 10000),
);

final Logger loggerSimple = Logger(
  printer: SimplePrinter(), // No boxing, no line length limits
);