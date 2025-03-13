import 'dart:convert';
import 'package:http/http.dart' as http;

class Response {
  final int statusCode;
  String? message;
  Map<String, dynamic> body;

  Response({
    required this.statusCode,
    this.message,
    Map<String, dynamic>? body
  }): body = body ?? {};

  factory Response.fromResponse(http.Response response) {
    Map<String, dynamic> body = jsonDecode(response.body) as Map<String, dynamic>;
    return Response(
      statusCode: response.statusCode,
      message: body['message'],
      body: body['body'],
    );
  }

  bool get isSuccess {
    return statusCode >= 200 && statusCode <= 299;
  }

  bool get isError {
    return !isSuccess;
  }
}