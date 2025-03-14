import 'dart:convert';

import 'response.dart';
import 'package:http/http.dart' as http;

class ValidationError {
  String field;
  final String error;
  final String errorDescription;
  final dynamic value;

  ValidationError({
    required this.field,
    required this.error,
    required this.errorDescription,
    this.value,
  });

  factory ValidationError.fromJson(Map<String, dynamic> json) => ValidationError(
    field: json['field'],
    error: json['error'],
    errorDescription: json['error_description'],
    value: json['value'],
  );

  int? valueAsInt() {
    return int.tryParse(value);
  }
}

Map<String, dynamic> _addField(Map<String, dynamic> map, String field) {
    map['field'] = field;
    return map;
  }

Map<String, List<ValidationError>> _buildErrors(Map<String, dynamic> body) {
  Map<String, List<ValidationError>> errors = {};

  for (final field in body.keys) {
    final value = body[field] as List<dynamic>;
    errors[field] = value.map((d) => ValidationError.fromJson(_addField(d, field))).toList();
  }
  return errors;
}

class ValidationFailedResponse extends Response {

  final Map<String, List<ValidationError>> errors; 

  ValidationFailedResponse({required super.statusCode, required this.errors,});

  factory ValidationFailedResponse.fromResponse(http.Response response) => ValidationFailedResponse(
    statusCode: response.statusCode,
    errors: _buildErrors(jsonDecode(response.body)['body'] as Map<String, dynamic>),
  );

  List<String> get invalidFields {
    return errors.keys.toList();
  }

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