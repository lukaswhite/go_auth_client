import 'package:flutter/material.dart';
import 'package:go_auth_client/auth/view/auth_widget.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  static const route = '/auth';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0,),
            child: AuthWidget(),
          ),
        ],
      ),
    );
  }
}