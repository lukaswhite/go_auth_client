import 'package:flutter/material.dart';
import 'package:go_auth_client/auth/view/signup_form.dart';
import 'package:go_auth_client/auth/view/login_form.dart';
import 'package:go_auth_client/auth/view/auth_widget.dart';
import 'package:go_auth_client/auth/cubit/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_auth_client/auth/view/logout_button.dart';
import 'router/router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (_) => GetIt.I.get<AuthCubit>(),
      child: MaterialApp.router(
        title: 'Go Auth',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) => (state is AuthAuthenticated) ? Text(state.user.name) : Text('not authenticated'),
            ),
            LogoutButton(),
            AuthWidget(),
            //LoginForm(),
            //SignupForm(),            
          ],
        ),
      ),
    );
  }
}