import 'package:flutter/material.dart';
import 'package:go_auth_client/auth/bloc/signup_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:go_auth_client/auth/http/requests/signup_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_auth_client/auth/auth_repository.dart';
import 'package:go_auth_client/http/responses/responses.dart';
import 'package:go_auth_client/forms/view/form_element_wrapper.dart';
import 'package:go_auth_client/forms/view/form_validation_error.dart';
import 'package:go_auth_client/forms/view/form_validation_errors.dart';
import 'package:get_it/get_it.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({super.key});

  FormGroup get form => fb.group(<String, Object>{
    'username': ['', Validators.required, Validators.minLength(6)],
    'name': ['', Validators.required],
    'password': ['', Validators.required],
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignupBloc>(
      create: (_) => SignupBloc(authRepository: GetIt.I.get<AuthRepository>()),
      child: BlocListener<SignupBloc, SignupState>(
        listener: (context, state) {
          if(state is SignupComplete) {
            print('COMPLETE');
          }
        },
        child: BlocBuilder<SignupBloc, SignupState>(
          builder: (context, state) => ReactiveFormBuilder(
            form: () => form,
            builder: (context, form, child) {
              return Column(
                children: [
                  Text(state.toString()),
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
                      readOnly: (state is SignupSubmitting),
                    ),
                  ),
                  if (state is SignupError && state.response is ValidationFailedResponse) 
                    FormValidationErrors(errors: (state.response as ValidationFailedResponse).getErrors('username')), 
                  if (state is SignupError && state.response is DuplicateEntityResponse && (state.response as DuplicateEntityResponse).field == 'username')
                    Text('That username is taken'),
                  FormElementWrapper(
                    child: ReactiveTextField<String>(
                      formControlName: 'name',
                      decoration: const InputDecoration(
                        labelText: 'Name',
                      ),
                      validationMessages: {
                        ValidationMessage.required: (_) => 'Name must not be empty',
                      },
                      readOnly: (state is SignupSubmitting),
                    ),
                  ),
                  if (state is SignupError && state.response is ValidationFailedResponse) 
                    FormValidationErrors(errors: (state.response as ValidationFailedResponse).getErrors('name')), 
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
                      readOnly: (state is SignupSubmitting),
                    ),
                  ),
                  if (state is SignupError && state.response is ValidationFailedResponse) 
                    FormValidationErrors(errors: (state.response as ValidationFailedResponse).getErrors('password')), 
                  ReactiveFormConsumer(
                    builder: (context, form, child) {
                      return FormElementWrapper(
                        child: ElevatedButton(
                          //onPressed: form.valid ? () => print(form.value) : null,
                          onPressed: (state is! SignupSubmitting) ? () {
                            form.markAllAsTouched();
                            if(!form.valid) {
                              return;
                            }
                            SignupRequest request = SignupRequest.fromMap(form.value);
                            context.read<SignupBloc>().add(SignupSubmit(request: request));
                          } : null,
                          child: const Text('Sign Up'),
                        ),
                      );
                    },
                  ),
                ]
              );
            }
          ),
        ),
      ),
    );
  }
}