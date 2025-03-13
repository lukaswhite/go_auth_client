part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();
  
  @override
  List<Object> get props => [];
}

final class LoginInitial extends LoginState {}

final class LoginSubmitting extends LoginState {
  final LoginRequest request;

  const LoginSubmitting({
    required this.request,
  });

  @override
  List<Object> get props => [request,];
}

final class LoginError extends LoginState {
  final LoginRequest request;
  final Response response;

  const LoginError({
    required this.request,
    required this.response,
  });

  @override
  List<Object> get props => [request, response,];
}

final class LoginComplete extends LoginState {
  final User user;

  const LoginComplete({
    required this.user,
  });

  @override
  List<Object> get props => [user,];
}
