import 'package:flutter/material.dart';
import 'package:go_auth_client/auth/cubit/auth_widget_cubit.dart';
import 'package:go_auth_client/auth/view/auth_widget.dart';

class AuthScreen extends StatelessWidget {
  
  final AuthWidgetView? initalView;
  
  const AuthScreen({super.key, this.initalView,});

  static const route = '/auth';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0,),
            child: AuthWidget(initialView: initalView,),
          ),
        ],
      ),
    );
  }
}