import 'package:flutter/material.dart';
import 'package:go_auth_client/auth/models/user.dart';
import 'package:go_auth_client/auth/cubit/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef AuthBuilderBuildFunc = Widget Function(BuildContext context, User user);

// ignore: must_be_immutable
class AuthBuilder extends StatelessWidget {

  final AuthBuilderBuildFunc builder;
  Widget? anonymous;

  AuthBuilder({super.key, required this.builder, this.anonymous,});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return builder(context, state.user);
        }
        return anonymous ?? const SizedBox();
      }
    );
  }
}