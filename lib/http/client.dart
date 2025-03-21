import 'dart:convert';
import '../auth/models/models.dart';
import 'responses/responses.dart';
import 'package:http/http.dart' as http;
import 'package:http_status_code/http_status_code.dart';

typedef ResponseBuilder = Response Function(http.Response);

class ClientConfig {

  final String hostname;
  final int port;
  final bool isHttps;
  
  ClientConfig({
    required this.hostname,
    this.port = 443,
    this.isHttps = true,
  });

  factory ClientConfig.fromJson(Map<String, dynamic> json) => ClientConfig(
    hostname: json['hostname'],
    port: json['port'] ?? 443,
    isHttps: json['is_https'] ?? true,
  );

  ClientConfig.http(this.hostname): port = 80, isHttps = false;
  ClientConfig.https(this.hostname): port = 443, isHttps = true;
}

class Client {

  final http.Client _client;
  final ClientConfig config;
  Token? accessToken;

  Client({
    http.Client? client,
    required this.config,
  }): _client = client ?? http.Client();
  
  bool get hasAccessToken {
    return accessToken != null;
  }

  Future<Response?> post(String path, Map<String, String> payload, {ResponseBuilder? responseBuilder,}) async {
    try {
      var response = await _client.post(
        url(path), 
        headers: _headers(),
        body: jsonEncode(payload),
      );
      return _convertResponse(response, responseBuilder: responseBuilder,);
    } catch (e) {
      // debugPrint(e.toString());
    }
    
  }

  Response _convertResponse(http.Response response, {ResponseBuilder? responseBuilder,}) {
    if(response.statusCode == StatusCode.UNAUTHORIZED) {
      return UnauthorizedResponse();
    }
    if(response.statusCode == StatusCode.FORBIDDEN) {
      return AccessDeniedResponse();
    }
    if(response.statusCode == StatusCode.NOT_FOUND) {
      return NotFoundResponse();
    }
    if(response.statusCode == StatusCode.UNPROCESSABLE_ENTITY) {
      return ValidationFailedResponse.fromResponse(response);
    }
    if(response.statusCode == StatusCode.CONFLICT) {
      return DuplicateEntityResponse.fromResponse(response);
      //return DuplicateEntityResponse(statusCode: response.statusCode, field: jsonDecode(response.body)['body']['field']);
    }
    if(response.statusCode == StatusCode.INTERNAL_SERVER_ERROR) {
      return ServerErrorResponse();
    }
    if(responseBuilder != null) {
      return responseBuilder(response);
    }
    return Response.fromResponse(response);
  }

  Uri url(String path) {
    String authority = config.hostname;
    if(config.isHttps && config.port != 443) {
      authority = '${config.hostname}:${config.port}';
    } else if (!config.isHttps && config.port != 80) {
      authority = '${config.hostname}:${config.port}';
    }
    return config.isHttps ? Uri.https(authority, path) : Uri.http(authority, path);
  }

  Map<String, String> _headers() {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    if(hasAccessToken) {
      headers['Authorization'] = "Bearer ${accessToken!.token}";
    }
    return headers;
  }

}