import 'package:flutter/material.dart';
import 'package:go_auth_client/auth/bloc/login_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:go_auth_client/auth/http/requests/login_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_auth_client/auth/auth_repository.dart';
import 'package:go_auth_client/http/responses/responses.dart';
import 'package:go_auth_client/forms/view/form_element_wrapper.dart';
import 'package:go_auth_client/forms/view/form_error.dart';
import 'package:pretty_animated_buttons/pretty_animated_buttons.dart';
import 'package:get_it/get_it.dart';
import 'package:quickalert/quickalert.dart';
import 'package:animated_visibility/animated_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:go_auth_client/ui/view/loading_overlay.dart';
import 'package:flutter_translate/flutter_translate.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  FormGroup get form => fb.group(<String, Object>{
    'username': ['', Validators.required,],
    'password': ['', Validators.required],
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (_) => LoginBloc(authRepository: GetIt.I.get<AuthRepository>()),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if(state is LoginComplete) {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              text: 'You have logged in successfully',
              onConfirmBtnTap: () {
                Navigator.of(context).pop();
                GoRouter.of(context).replace('/');
              }
            );
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) => LoadingOverlay(
            visible: (state is LoginSubmitting),
            child: ReactiveFormBuilder(
              form: () => form,
              builder: (context, form, child) {
                return Column(
                  children: [
                    AnimatedVisibility(
                      visible: (state is LoginError && state.response is UnauthorizedResponse) ,
                      child: FormError(message: translate('auth.login.errors.credentials.message')),           
                    ),
                    FormElementWrapper(
                      child: ReactiveTextField<String>(
                        formControlName: 'username',
                        decoration: InputDecoration(
                          labelText: translate('auth.login.form.fields.username.label'),
                        ),
                        validationMessages: {
                          ValidationMessage.required: (_) => translate('auth.login.form.fields.username.errors.required'),
                        },
                        readOnly: (state is LoginSubmitting),
                      ),
                    ),
                    FormElementWrapper(
                      child: ReactiveTextField<String>(
                        formControlName: 'password',
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: translate('auth.login.form.fields.password.label'),
                        ),
                        validationMessages: {
                          ValidationMessage.required: (_) => translate('auth.login.form.fields.password.errors.required'),
                        },
                        readOnly: (state is LoginSubmitting),
                      ),
                    ),
                    ReactiveFormConsumer(
                      builder: (context, form, child) {
                        return FormElementWrapper(
                          child: PrettyWaveButton(
                          //onPressed: form.valid ? () => print(form.value) : null,
                            onPressed: () {
                              form.markAllAsTouched();
                              if(!form.valid) {
                                return;
                              }
                              LoginRequest request = LoginRequest.fromMap(form.value);
                              context.read<LoginBloc>().add(LoginSubmit(request: request));
                            },
                            child: Text(
                              translate('auth.login.form.submit.label'), 
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ]
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}