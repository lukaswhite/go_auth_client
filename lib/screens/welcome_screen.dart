import 'package:flutter/material.dart';
import 'package:go_auth_client/auth/view/auth_builder.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const route = '/welcome';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AuthBuilder(
            builder: (context, user) => Text(user.name),
          ),
          TextButton(
            onPressed: () => GoRouter.of(context).go('/'), 
            child: const Text('Home'),
          )
        ],
      ),
    );
  }
}