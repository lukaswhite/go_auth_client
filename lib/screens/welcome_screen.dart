import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const route = '/welcome';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('This is the welcome screen'),
    );
  }
}