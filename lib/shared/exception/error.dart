import 'opusb_exception.dart';

class ErrorMsg extends OpusbException {
  ErrorMsg([String message = 'test']) : super(message);
}
