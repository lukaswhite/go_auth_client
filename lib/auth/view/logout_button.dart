import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_auth_client/auth/auth_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:go_auth_client/auth/cubit/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/quickalert.dart';
import 'package:go_router/go_router.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) => (state is AuthAuthenticated) ? _LogoutButton() : const SizedBox(),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  _LogoutButton();

  final AuthRepository _authRepository = GetIt.I.get<AuthRepository>();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        text: 'Are you sure you want to log out?',
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
          unawaited(_authRepository.logout());
          GoRouter.of(context).replace('/');
        }
      ),
      child: const Text('Log out'),
    );
  }
}