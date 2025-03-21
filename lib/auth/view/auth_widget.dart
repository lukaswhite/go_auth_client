import 'package:flutter/material.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_auth_client/auth/cubit/auth_widget_cubit.dart';
import 'login_form.dart';
import 'signup_form.dart';
import 'package:flutter_translate/flutter_translate.dart';

class AuthWidget extends StatelessWidget {

  final AuthWidgetView? initialView;

  const AuthWidget({super.key, this.initialView,});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthWidgetCubit>(
      create: (_) => AuthWidgetCubit(view: initialView),
      child: BlocBuilder<AuthWidgetCubit, AuthWidgetState>(
        builder: (context, state) => Column(
          children: [
            CustomSlidingSegmentedControl<AuthWidgetView>(
              initialValue: initialView ?? AuthWidgetView.login,
              isStretch: true,
              children: {
                AuthWidgetView.login: Text(
                  translate('auth.tabs.login.label'),
                  textAlign: TextAlign.center,
                ),
                AuthWidgetView.signup: Text(
                  translate('auth.tabs.signup.label'),
                  textAlign: TextAlign.center,
                ),
              },
              //innerPadding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(14),
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
                child: child,
              ), 
              child: (state as AuthWidgeDisplay).view == AuthWidgetView.login ? 
                const LoginForm() : SignupForm(),
            ),
          ],
        ),
      ),
    );
  }
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