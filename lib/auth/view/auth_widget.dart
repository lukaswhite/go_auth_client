import 'package:flutter/material.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_auth_client/auth/cubit/auth_widget_cubit.dart';
import 'login_form.dart';
import 'signup_form.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthWidgetCubit>(
      create: (_) => AuthWidgetCubit(),
      child: BlocBuilder<AuthWidgetCubit, AuthWidgetState>(
        builder: (context, state) => Column(
          children: [
            //Text(context.read<AuthWidgetCubit>().state.toString()),
            CustomSlidingSegmentedControl<AuthWidgetView>(
              initialValue: AuthWidgetView.login,
              isStretch: true,
              children: const {
                AuthWidgetView.login: Text(
                  'Log In',
                  textAlign: TextAlign.center,
                ),
                AuthWidgetView.signup: Text(
                  'Sign Up',
                  textAlign: TextAlign.center,
                ),
              },
              innerPadding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                //borderRadius: BorderRadius.circular(14),
              ),
              thumbDecoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              onValueChanged: (v) {
                context.read<AuthWidgetCubit>().select(v);
              },
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250,),
              transitionBuilder: (child, animation) => SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, -0.05), end: const Offset(0, 0)).animate(animation),
                child: child
              ), 
              child: (state as AuthWidgeDisplay).view == AuthWidgetView.login ? 
                const LoginForm() : const SignupForm(),
            ),
          ]),
        //builder: (context, state) => Text('tabs'),
      ),
    );}
    /** 
    return BlocProvider<AuthWidgetCubit>(
      create: (_) => AuthWidgetCubit(),
      child: Column(
          children: [
            //Text(context.read<AuthWidgetCubit>().state.toString()),
            CustomSlidingSegmentedControl<AuthWidgetView>(
              initialValue: AuthWidgetView.login,
              isStretch: true,
              children: const {
                AuthWidgetView.login: Text(
                  'Log In',
                  textAlign: TextAlign.center,
                ),
                AuthWidgetView.signup: Text(
                  'Sign Up',
                  textAlign: TextAlign.center,
                ),
              },
              innerPadding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(14),
              ),
              thumbDecoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              onValueChanged: (v) {
                print(v);
                context.read<AuthWidgetCubit>().select(v);
              },
            ),
            BlocBuilder<AuthWidgetCubit, AuthWidgetState>(
        builder: (context, state) {
        return 
            DefaultTabController(
              length: 2, 
              initialIndex: (state as AuthWidgeDisplay).tabIndex,
              child: SizedBox(height: 220, child: TabBarView(
                children: [
                  Text('log in'),
                  Text('Sign up')
                ],
              )),
            );
        }),
          ]
        )
        
    );
  }**/
}

class _AuthWidgetTab extends StatelessWidget {
  
  final Widget child;
  
  const _AuthWidgetTab({required this.child,});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: child,
    );
  }
}