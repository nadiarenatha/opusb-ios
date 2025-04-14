import 'package:logger/logger.dart';

Logger getLogger(String className) {
  return Logger(printer: SimpleLogPrinter(className));
}

class SimpleLogPrinter extends LogPrinter {
  final String className;
  SimpleLogPrinter(this.className);

  @override
  List<String> log(LogEvent event) {
    // var color = PrettyPrinter.levelColors[event.level]; // deprecated
    var color = PrettyPrinter.defaultLevelColors[event.level];
    // var emoji = PrettyPrinter.levelEmojis[event.level]; // deprecated
    var emoji = PrettyPrinter.defaultLevelEmojis[event.level];
    return [color!('$emoji $className - ${event.message}')];
  }
}
