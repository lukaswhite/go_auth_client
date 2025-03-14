import 'package:flutter/material.dart';
import 'package:go_auth_client/auth/bloc/login_bloc.dart';
import 'package:quickalert/models/quickalert_options.dart';
import 'package:quickalert/widgets/quickalert_container.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:go_auth_client/auth/http/requests/login_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_auth_client/auth/auth_repository.dart';
import 'package:go_auth_client/http/responses/responses.dart';
import 'package:go_auth_client/forms/view/form_element_wrapper.dart';
import 'package:go_auth_client/forms/view/form_error.dart';
import 'package:go_auth_client/forms/view/form_validation_errors.dart';
import 'package:go_auth_client/forms/view/form_validation_error.dart';
import 'package:pretty_animated_buttons/pretty_animated_buttons.dart';
import 'package:get_it/get_it.dart';
import 'package:quickalert/quickalert.dart';
import 'package:animated_visibility/animated_visibility.dart';

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
                print('OK');
                Navigator.of(context).pop();
              }
            );
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) => Stack(
            children: [
              ReactiveFormBuilder(
              form: () => form,
              builder: (context, form, child) {
                return Column(
                  children: [
                    AnimatedVisibility(
                      visible: (state is LoginError && state.response is UnauthorizedResponse) ,
                      child: const FormError(message: 'Username or password is incorrect'),           
                    ),
                    FormElementWrapper(
                      child: ReactiveTextField<String>(
                        formControlName: 'username',
                        decoration: const InputDecoration(
                          labelText: 'Username',
                        ),
                        validationMessages: {
                          ValidationMessage.required: (_) => 'Username must not be empty',
                          ValidationMessage.minLength: (error) => 'The username must be at least ${(error as Map)['requiredLength']} characters long'
                        },
                        readOnly: (state is LoginSubmitting),
                      ),
                    ),
                    FormElementWrapper(
                      child: ReactiveTextField<String>(
                        formControlName: 'password',
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                        validationMessages: {
                          ValidationMessage.required: (_) => 'Password must not be empty',
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
                            child: const Text('Log in', style: TextStyle(color: Colors.white),),
                          ),
                        );
                      },
                    ),
                  ]
                );
              }
            ),
            Positioned.fill(
              child: AnimatedVisibility(
                visible: (state is LoginSubmitting),
                child: Container(
                  color: const Color.fromARGB(180, 0, 0, 0),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
      )
            /** 
            if(state is LoginSubmitting) Positioned.fill(
                child: Container(
                  color: const Color.fromARGB(200, 0, 0, 0),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              **/
            ],
          ),
        ),
      ),
    );
  }
}