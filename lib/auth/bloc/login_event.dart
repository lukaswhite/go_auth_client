part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginSubmit extends LoginEvent {
  final LoginRequest request;

  const LoginSubmit({
    required this.request,
  });

  @override
  List<Object> get props => [request,];
}