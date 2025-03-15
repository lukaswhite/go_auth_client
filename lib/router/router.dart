import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_auth_client/auth/auth_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:go_auth_client/screens/screens.dart';

final _authRepository = GetIt.I.get<AuthRepository>();

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AuthScreen.route,
      builder: (context, state) => const AuthScreen(),
      redirect: (BuildContext context, GoRouterState state) {
        if (_authRepository.isAuthenticated) {
          return '/';
        } else {
          return null;
        }   
      },
    ),
    GoRoute(
      path: AccountScreen.route,
      builder: (context, state) => const AccountScreen(),
      redirect: (BuildContext context, GoRouterState state) {
        if (!_authRepository.isAuthenticated) {
          return '/';
        } else {
          return null;
        }   
      },
    ),
    GoRoute(
      path: WelcomeScreen.route,
      builder: (context, state) => const WelcomeScreen(),
      redirect: (BuildContext context, GoRouterState state) {
        if (!_authRepository.isAuthenticated) {
          return '/';
        } else {
          return null;
        }   
      },
    ),
  ],
  redirect: (BuildContext context, GoRouterState state) {
    if (!_authRepository.isAuthenticated) {
      return null;
      //return '/auth';
    } else {
      return null;
    }   
  },
);