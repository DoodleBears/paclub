class AppResponse {
  late String _message;
  String get message => _message;

  dynamic _data;
  dynamic get data => _data;

  late String _exceptionType;
  String get exceptionType => _exceptionType;

  AppResponse(String message, dynamic data,
      [String exceptionType = 'NO_EXCEPTION_PROVIDED']) {
    _message = message;
    _data = data;
    _exceptionType = exceptionType;
  }

  @override
  String toString() {
    return 'Exception: $exceptionType\nMessage: $message';
  }
}
