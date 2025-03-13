import 'dart:convert';

import 'response.dart';
import 'package:http/http.dart' as http;

class ValidationError {
  final String error;
  final String errorDescription;
  final dynamic value;

  ValidationError({
    required this.error,
    required this.errorDescription,
    this.value,
  });

  factory ValidationError.fromJson(Map<String, dynamic> json) => ValidationError(
    error: json['error'],
    errorDescription: json['error_description'],
    value: json['value'],
  );
}

Map<String, List<ValidationError>> buildErrors(Map<String, dynamic> body) {
  Map<String, List<ValidationError>> errors = {};
  for (final field in body.keys) {
    print(field);
    final value = body[field] as List<dynamic>;
    errors[field] = value.map((d) => ValidationError.fromJson(d)).toList();
    print(value);
    //print('$name,$value'); // prints entries like "AED,3.672940"
  }
  return errors;
}

class ValidationFailedResponse extends Response {

  final Map<String, List<ValidationError>> errors; 

  ValidationFailedResponse({required super.statusCode, required this.errors,});

  factory ValidationFailedResponse.fromResponse(http.Response response) => ValidationFailedResponse(
    statusCode: response.statusCode,
    errors: buildErrors(jsonDecode(response.body)['body'] as Map<String, dynamic>),
  );

  bool hasError(String field) {
    return errors[field] != null;
  }

  bool isValid(String field) {
    return !hasError(field);
  }

  ValidationError? first(String field) {
    if(!hasError(field)) {
      return null;
    }
    return getErrors(field).first;
  }

  List<ValidationError> getErrors(String field) {
    return hasError(field) ? errors[field]! : [];
  }

}