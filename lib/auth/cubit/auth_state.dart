part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthAnonymous extends AuthState {}

final class AuthAuthenticated extends AuthState {

  final User user;

  const AuthAuthenticated({
    required this.user,
  });

  @override
  List<Object> get props => [user,];
}
