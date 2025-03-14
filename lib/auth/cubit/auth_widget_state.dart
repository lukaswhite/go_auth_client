part of 'auth_widget_cubit.dart';

sealed class AuthWidgetState extends Equatable {
  const AuthWidgetState();

  @override
  List<Object> get props => [];
}

final class AuthWidgeDisplay extends AuthWidgetState {
  final AuthWidgetView view;

  const AuthWidgeDisplay({
    required this.view,
  });

  const AuthWidgeDisplay.login(): view = AuthWidgetView.login;
  const AuthWidgeDisplay.signup(): view = AuthWidgetView.signup;

  int get tabIndex {
    return view == AuthWidgetView.login ? 0 : 1;
  }

  @override
  List<Object> get props => [view,];
}
