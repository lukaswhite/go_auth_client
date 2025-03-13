import 'response.dart';

class ServerErrorResponse extends Response {
  
  ServerErrorResponse({int? statusCode}): super(statusCode: statusCode ?? 500,);
   
}