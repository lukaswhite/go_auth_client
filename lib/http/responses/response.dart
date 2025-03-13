class Response {
  final int statusCode;
  String? message;
  Map<String, dynamic> body;

  Response({
    required this.statusCode,
    this.message,
    Map<String, dynamic>? body
  }): body = body ?? {};

  bool get isSuccess {
    return statusCode >= 200 && statusCode <= 299;
  }

  bool get isError {
    return !isSuccess;
  }
}