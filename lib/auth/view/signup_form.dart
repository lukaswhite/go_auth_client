import 'package:flutter/material.dart';
import 'package:go_auth_client/auth/bloc/signup_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:go_auth_client/auth/http/requests/signup_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_auth_client/auth/auth_repository.dart';
import 'package:go_auth_client/http/responses/responses.dart';
import 'package:go_auth_client/forms/view/form_element_wrapper.dart';
import 'package:go_auth_client/forms/view/form_error.dart';
import 'package:go_auth_client/forms/view/form_validation_errors.dart';
import 'package:pretty_animated_buttons/pretty_animated_buttons.dart';
import 'package:get_it/get_it.dart';
import 'package:quickalert/quickalert.dart';
import 'package:go_router/go_router.dart';
import 'package:animated_visibility/animated_visibility.dart';
import 'package:go_auth_client/screens/welcome_screen.dart';
import 'package:password_strength_checker/password_strength_checker.dart';
import 'package:go_auth_client/ui/view/loading_overlay.dart';

class SignupForm extends StatelessWidget {
  SignupForm({super.key});

  FormGroup get form => fb.group(<String, Object>{
    'username': ['', Validators.required, Validators.minLength(6)],
    'name': ['', Validators.required],
    'password': ['', Validators.required],
  });

  final passNotifier = ValueNotifier<PasswordStrength?>(null);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignupBloc>(
      create: (_) => SignupBloc(authRepository: GetIt.I.get<AuthRepository>()),
      child: BlocListener<SignupBloc, SignupState>(
        listener: (context, state) {
          if(state is SignupComplete) {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              text: 'You have signed up successfully',
              onConfirmBtnTap: () {
                Navigator.of(context).pop();
                GoRouter.of(context).replace(WelcomeScreen.route);
              }
            );
          }
        },
        child: BlocBuilder<SignupBloc, SignupState>(
          builder: (context, state) => LoadingOverlay(
            visible: (state is SignupSubmitting),
            child: ReactiveFormBuilder(
            form: () => form,
            builder: (context, form, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AnimatedVisibility(
                    visible: (state is SignupError && state.response is DuplicateEntityResponse && (state.response as DuplicateEntityResponse).field == 'username'),
                    child: const FormError(message: 'That username is taken'),           
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
                      readOnly: (state is SignupSubmitting),
                    ),
                  ),
                  if (state is SignupError && state.response is ValidationFailedResponse) 
                    FormValidationErrors(errors: (state.response as ValidationFailedResponse).getErrors('username')), 
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
                      onChanged: (control) => passNotifier.value = PasswordStrength.calculate(text: control.value!),
                    ),
                  ),
                  /** 
                  PasswordStrengthChecker(
                    strength: passNotifier,
                  ),
                  **/
                  if (state is SignupError && state.response is ValidationFailedResponse) 
                    FormValidationErrors(errors: (state.response as ValidationFailedResponse).getErrors('password')), 
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
                            SignupRequest request = SignupRequest.fromMap(form.value);
                            context.read<SignupBloc>().add(SignupSubmit(request: request));
                          },
                          child: const Text('Sign Up', style: TextStyle(color: Colors.white),),
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
      ),
    );
  }
}