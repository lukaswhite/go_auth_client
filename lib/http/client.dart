import 'dart:convert';
import '../auth/models/models.dart';
import 'responses/responses.dart';
import 'package:http/http.dart' as http;

class ClientConfig {
  final String hostname;
  final int port;
  final bool isHttps;

  ClientConfig({
    required this.hostname,
    this.port = 443,
    this.isHttps = true,
  });

  ClientConfig.http(this.hostname): port = 80, isHttps = false;
  ClientConfig.https(this.hostname): port = 443, isHttps = true;
}

class Client {

  Client({
    required this.config,
  });

  final ClientConfig config;
  Token? accessToken;

  bool get hasAccessToken {
    return accessToken != null;
  }

  Future<Response> post(String path, Map<String, String> payload) async {
    var response = await http.post(
      url(path), 
      headers: _headers(),
      body: jsonEncode(payload),
    );
    return _convertResponse(response);
  }

  Response _convertResponse(http.Response response) {
    if(response.statusCode == 401) {
      return UnauthorizedResponse();
    }
    if(response.statusCode == 404) {
      return NotFoundResponse();
    }
    if(response.statusCode == 422) {
      return ValidationFailedResponse.fromResponse(response);
    }
    if(response.statusCode == 409) {
      return DuplicateEntityResponse(statusCode: response.statusCode, field: jsonDecode(response.body)['body']['field']);
    }
    if(response.statusCode == 500) {
      return ServerErrorResponse();
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