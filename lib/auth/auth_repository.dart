import 'dart:convert';
import 'package:go_auth_client/auth/http/requests/login_request.dart';

import 'models/models.dart';
import 'package:go_auth_client/http/requests/requests.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_auth_client/http/client.dart';
import 'package:dartz/dartz.dart';
import 'package:go_auth_client/http/responses/response.dart';
import 'package:rxdart/rxdart.dart';

enum AuthStatus { authenticated, anonymous }

class AuthResult {

  final AuthStatus status;
  User? user;

  AuthResult.authenticated(User this.user): status = AuthStatus.authenticated;
  AuthResult.anonymous(): status = AuthStatus.anonymous;

  bool get isAuthenticated {
    return status == AuthStatus.authenticated;
  }

}

class AuthRepository {

  final Client client;
  Token? token;
  User? user;
  final storage = const FlutterSecureStorage();
  final BehaviorSubject<AuthResult> auth;

  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';

  AuthRepository({
    required this.client,
  }): auth = BehaviorSubject<AuthResult>() {
    auth.add(AuthResult.anonymous());
  }

  Future<void> init() async {
    //await storage.deleteAll();
    String? tokenStr = await storage.read(key: _tokenKey);
    if(tokenStr != null) {
      token = Token.fromJson(json.decode(tokenStr));
    }
    String? userStr = await storage.read(key: _userKey);
    if(userStr != null) {
      user = User.fromJson(json.decode(userStr));
    }
    if(token != null && user != null) {
      auth.add(AuthResult.authenticated(user!));
    }
  }

  bool get isAuthenticated {
    return token != null;
  }

  Future<Either<User, Response>> signup(SignupRequest request) async {
    final response = await client.post('signup', request.toJson());
    if(response.isError) {
      return Right(response);
    }
    //(Token token, User user) = 
    final Token token = Token.fromJson(response.body['token']);
    final User user = User.fromJson(response.body['user']);
    //var record = parseResponse(response);
    await _authenticate(token: token, user: user,);
    return Left(user);
    /**
    var record = parseResponse(response);
    await _authenticate(token: record.$1, user: record.$2,);
    return Left(record.$2);
     */
  }

  (Token, User) parseResponse(Response response) {
    return (
      Token.fromJson(response.body['token']),
      User.fromJson(response.body['user'])
    );
  }

  Future<Either<User, Response>> login(LoginRequest request) async {
    final response = await client.post('login', request.toJson());
    if(response.isError) {
      return Right(response);
    }
    final Token token = Token.fromJson(response.body['token']);
    final User user = User.fromJson(response.body['user']);
    await _authenticate(token: token, user: user,);
    return Left(user);
  }

  Future<void> logout() async {
    await storage.delete(key: _tokenKey);
    await storage.delete(key: _userKey);
    token = null;
    user = null;
    client.accessToken = null;
    auth.add(AuthResult.anonymous());
  }

  Future<void> _authenticate({required Token token, required User user}) async {
    client.accessToken = token;
    this.token = token;
    user = user;
    await _save(token: token, user: user);
    auth.add(AuthResult.authenticated(user));
  }

  Future<void> _save({required Token token, required User user}) async {
    await storage.write(key: _tokenKey, value: json.encode(token));
    await storage.write(key: _userKey, value: json.encode(user));
  }
}