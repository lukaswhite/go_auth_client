part of 'signup_bloc.dart';

sealed class SignupState extends Equatable {
  const SignupState();
  
  @override
  List<Object> get props => [];
}

final class SignupInitial extends SignupState {}

final class SignupSubmitting extends SignupState {
  final SignupRequest request;

  const SignupSubmitting({
    required this.request,
  });

  @override
  List<Object> get props => [request,];
}

final class SignupError extends SignupState {
  final SignupRequest request;
  final Response response;

  const SignupError({
    required this.request,
    required this.response,
  });

  @override
  List<Object> get props => [request, response,];
}

final class SignupComplete extends SignupState {
  final User user;

  const SignupComplete({
    required this.user,
  });

  @override
  List<Object> get props => [user,];
}
