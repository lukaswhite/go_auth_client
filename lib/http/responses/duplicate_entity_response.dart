import 'response.dart';

class DuplicateEntityResponse extends Response {
  
  final String field;
  
  DuplicateEntityResponse({required super.statusCode, required this.field,});

}