import 'dart:convert';
import 'response.dart';
import 'package:http/http.dart' as http;

class DuplicateEntityResponse extends Response {
  
  final String field;
  
  DuplicateEntityResponse({required super.statusCode, required this.field,});

  factory DuplicateEntityResponse.fromResponse(http.Response response) => DuplicateEntityResponse(
    statusCode: response.statusCode,
    field: jsonDecode(response.body)['body']['field'],
  );
}