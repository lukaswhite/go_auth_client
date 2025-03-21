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
import 'package:go_router/go_router.dart';
import 'package:animated_visibility/animated_visibility.dart';
import 'package:go_auth_client/screens/welcome_screen.dart';
import 'package:password_strength_checker/password_strength_checker.dart';
import 'package:go_auth_client/ui/view/loading_overlay.dart';
import 'package:password_complexity/password_complexity.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ReactiveFormsPasswordComplexityValidator extends Validator<dynamic> {
  
  final PasswordComplexityConfig config;
  final PasswordComplexityValidator _validator;

  ReactiveFormsPasswordComplexityValidator({
    required this.config,
  }): _validator = PasswordComplexityValidator(config: config), super();

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    return control.isNotNull &&
      _validator.check(control.value).isValid
    ? null
    : {'passwordComplexity': true};
  }
}

class SignupForm extends StatelessWidget {
  SignupForm({super.key});

  FormGroup get form => fb.group(<String, Object>{
    'username': ['', Validators.required, Validators.minLength(3)],
    'name': ['', Validators.required],
    'password': ['', ReactiveFormsPasswordComplexityValidator(config: passwordComplexityConfig,)],
  });

  final passNotifier = ValueNotifier<PasswordStrength?>(null);
  final passwordValue = ValueNotifier<String?>(null);

  final passwordComplexityConfig = PasswordComplexityConfig(
    minLength: 8,
    minDigits: 1,
    minLowercase: 1,
    minUppercase: 1,
    minSymbols: 1,
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignupBloc>(
      create: (_) => SignupBloc(authRepository: GetIt.I.get<AuthRepository>()),
      child: BlocListener<SignupBloc, SignupState>(
        listener: (context, state) {
          if(state is SignupComplete) {
            GoRouter.of(context).replace(WelcomeScreen.route);
          } else if (state is SignupError && state.response is ValidationFailedResponse) {
            var c = form.control('name');
              c.setErrors({'required' : true});
              c.markAsTouched();
            for(var entry in (state.response as ValidationFailedResponse).errors.entries) {
              var c = form.control(entry.key);
              c.setErrors({entry.value.first.error : true});
              c.markAsTouched();
            }
            c.markAllAsTouched();
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
                    child: FormError(
                      message: translate('auth.signup.errors.username_taken.message'),
                      footerBuilder: () => TextButton(
                        onPressed: () => context.push('/auth/login'), 
                        child: Text(
                          translate('auth.signup.errors.username_taken.footer.action'), 
                          style: TextStyle(color: Theme.of(context).colorScheme.onError,),
                        ),
                      ),
                    ),      
                  ),
                  FormElementWrapper(
                    child: ReactiveTextField<String>(
                      formControlName: 'username',
                      decoration: InputDecoration(
                        labelText: translate('auth.signup.form.fields.username.label'),
                      ),
                      validationMessages: {
                        ValidationMessage.required: (_) => translate('auth.signup.form.fields.username.errors.required'),
                        //ValidationMessage.minLength: (error) => 'The username must be at least ${(error as Map)['requiredLength']} characters long'
                        ValidationMessage.minLength: (error) => translatePlural('auth.signup.form.fields.username.errors.min_length.plural', (error as Map)['requiredLength'])
                      },
                      readOnly: (state is SignupSubmitting),
                    ),
                  ),
                  if (state is SignupError && state.response is ValidationFailedResponse) 
                    FormValidationErrors(errors: (state.response as ValidationFailedResponse).getErrors('username')), 
                  FormElementWrapper(
                    child: ReactiveTextField<String>(
                      formControlName: 'name',
                      decoration: InputDecoration(
                        labelText: translate('auth.signup.form.fields.name.label'),
                      ),
                      validationMessages: {
                        ValidationMessage.required: (_) => translate('auth.signup.form.fields.name.errors.required'),
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
                      decoration: InputDecoration(
                        labelText: translate('auth.signup.form.fields.password.label'),
                      ),
                      validationMessages: {
                        ValidationMessage.required: (_) => translate('auth.signup.form.fields.password.errors.required'),
                        'passwordComplexity': (_) => translate('auth.signup.form.fields.password.errors.complexity'),
                      },
                      readOnly: (state is SignupSubmitting),
                      onChanged: (control) => passwordValue.value = control.value!,
                    ),
                  ),
                  ReactiveFormConsumer(
                    builder: (context, form, child) {
                      //if(!form.control('password').hasErrors || !form.control('password').touched) return const SizedBox();
                      return Padding(
                        padding: const EdgeInsets.only(left: 12.0,),
                        child: PasswordComplexityWidget(
                          config: passwordComplexityConfig, 
                          value: passwordValue,
                          theme: PasswordComplexityTheme(
                            invalidColor: Theme.of(context).textTheme.bodyMedium!.color!,
                            textStyle: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color)),
                        ),
                      );
                    }
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
                          child: Text(
                            translate('auth.signup.form.submit.label'), 
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
            }
            ),
          ),
        ),
      ),
    );
  }
}