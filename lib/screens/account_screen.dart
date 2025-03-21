import 'package:flutter/material.dart';
import 'package:go_auth_client/auth/view/auth_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:go_auth_client/auth/view/logout_button.dart';

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
        builder: (context, user) => Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20.0,),
              Image.asset('images/avatar.png'),
              const SizedBox(height: 20.0,),
              Text(user.name, style: Theme.of(context).textTheme.headlineMedium,),
              const SizedBox(height: 5.0,),
              Text('@${user.username}', style: Theme.of(context).textTheme.headlineSmall,),
              const SizedBox(height: 20.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(onPressed: () => GoRouter.of(context).go('/'), child: const Text('Home')),
                  const Text(' | '),
                  const LogoutButton(),
                ],)
            ],
          ),
        ),
      ),
    );
  }
}