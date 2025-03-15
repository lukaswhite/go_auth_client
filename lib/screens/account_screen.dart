import 'package:flutter/material.dart';
import 'package:go_auth_client/auth/view/auth_builder.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  static const route = '/account';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Account'),
      ),
      body: AuthBuilder(
        builder: (context, user) => Text(user.name),
      ),
    );
  }
}