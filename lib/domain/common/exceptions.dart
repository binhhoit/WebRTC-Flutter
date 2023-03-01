class UnAuthenticateException implements Exception {}

class ConnectionException implements Exception {}

class ManuallyException implements Exception {

  final String message;

  ManuallyException(this.message);

  @override
  String toString() => message;
}