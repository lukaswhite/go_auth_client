import 'package:flutter/material.dart';
import 'app.dart';
import 'package:get_it/get_it.dart';
import 'package:go_auth_client/auth/auth_repository.dart';
import 'package:go_auth_client/http/client.dart';

void main() async {

  final ClientConfig clientConfig = ClientConfig(
    hostname: 'localhost',
    port: 3001,
    isHttps: false,
  );
  final Client client = Client(config: clientConfig);
  final AuthRepository authRepository = AuthRepository(client: client,);
  GetIt.I.registerSingleton(authRepository);
  await authRepository.init();

  runApp(const App());
}