import 'dart:convert';
import '../../models/models.dart';
import 'package:go_auth_client/http/responses/responses.dart';
import 'package:http/http.dart' as http;

class TokenResponse extends Response {

  final Token token;
  User? user;

  TokenResponse({required this.token, this.user,}): super(statusCode: 200,);

  factory TokenResponse.fromResponse(http.Response response) {
    Map<String, dynamic> body = jsonDecode(response.body)['body'] as Map<String, dynamic>;
    return TokenResponse(
      token: Token.fromJson(body['token']),
      user: body['user'] != null ? User.fromJson(body['user']) : null,
    );
  }
}