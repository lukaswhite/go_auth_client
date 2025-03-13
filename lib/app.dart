import 'package:flutter/material.dart';
import 'package:go_auth_client/auth/view/signup_form.dart';
import 'package:go_auth_client/auth/view/login_form.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Go Auth',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(title: 'Go Auth'),
    );
  }
}

class HomePage extends StatelessWidget {
  
  final String title;

  const HomePage({super.key, required this.title,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LoginForm(),
            //SignupForm(),            
          ],
        ),
      ),
    );
  }
}