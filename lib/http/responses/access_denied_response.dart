import 'dart:convert';
import 'package:http/http.dart' as http;
import 'response.dart';

class AccessDeniedResponse extends Response {
  
  AccessDeniedResponse({String? message}): super(statusCode: 403);
  
  factory AccessDeniedResponse.fromResponse(http.Response response) => AccessDeniedResponse(
    message: jsonDecode(response.body)['message']
  );

}