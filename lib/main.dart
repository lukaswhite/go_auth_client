import 'package:flutter/material.dart';
import 'app.dart';
import 'package:get_it/get_it.dart';
import 'package:go_auth_client/auth/auth_repository.dart';
import 'package:go_auth_client/http/client.dart';
import 'package:go_auth_client/auth/cubit/auth_cubit.dart';
import 'package:go_router/go_router.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  final ClientConfig clientConfig = ClientConfig(
    hostname: 'localhost',
    port: 3001,
    isHttps: false,
  );
  final Client client = Client(config: clientConfig);
  final AuthRepository authRepository = AuthRepository(client: client,);
  GetIt.I.registerSingleton(authRepository);
  GetIt.I.registerSingleton(AuthCubit(repository: authRepository));

  await authRepository.init();

  GoRouter.optionURLReflectsImperativeAPIs = true;

  runApp(const App());
}