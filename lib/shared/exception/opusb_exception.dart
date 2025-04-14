class OpusbException implements Exception {
  final String message;

  OpusbException(this.message);

  @override
  String toString() => message;
}
