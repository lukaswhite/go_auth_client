import 'response.dart';

class ClientErrorResponse extends Response {
  
  ClientErrorResponse({int? statusCode}): super(statusCode: statusCode ?? 400,);
   
}