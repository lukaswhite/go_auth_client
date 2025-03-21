import 'package:flutter/material.dart';
import 'package:go_auth_client/auth/cubit/auth_widget_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:go_auth_client/auth/view/logout_button.dart';
import 'package:go_auth_client/auth/cubit/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_auth_client/auth/view/auth_builder.dart';
import 'screens.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Home'),
        actions: [
          AuthBuilder(
            builder: (context, user) => IconButton(
              onPressed: () => context.push(AccountScreen.route), 
              icon: const Icon(Icons.person),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            AuthBuilder(
              builder: (context, user) => Text('Hello ${user.name}'),
              anonymous: const Text('You are not logged in'),
            ),
            AuthBuilder(
              builder: (context, user) => TextButton(onPressed: () => context.push(AccountScreen.route), child: const Text('Your account')),
            ),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) => (state is AuthAnonymous) ? 
                TextButton(onPressed: () => context.go('${AuthScreen.route}/${AuthWidgetView.login.name}'), child: const Text('Login')) :
                  const SizedBox(),
            ),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) => (state is AuthAnonymous) ? 
                TextButton(onPressed: () => context.go('${AuthScreen.route}/${AuthWidgetView.signup.name}'), child: const Text('Sign up')) :
                  const SizedBox(),
            ),
            const LogoutButton(),
          ],
        ),
      ),
    );
  }
}
