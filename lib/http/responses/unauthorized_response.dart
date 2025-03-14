import 'dart:convert';
import 'package:http/http.dart' as http;
import 'response.dart';

class UnauthorizedResponse extends Response {
  
  UnauthorizedResponse({String? message}): super(statusCode: 401);
  
  factory UnauthorizedResponse.fromResponse(http.Response response) => UnauthorizedResponse(
    message: jsonDecode(response.body)['message']
  );

}