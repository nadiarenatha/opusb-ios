import 'opusb_exception.dart';

class ServerException extends OpusbException {
  ServerException([String message = 'Server error']) : super(message);
}
