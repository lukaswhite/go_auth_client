import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_widget_state.dart';

enum AuthWidgetView { login, signup }

class AuthWidgetCubit extends Cubit<AuthWidgetState> {
  AuthWidgetCubit({
    AuthWidgetView? view,
  }) : super(AuthWidgeDisplay(view: view ?? AuthWidgetView.login));

  void select(AuthWidgetView view) {
    emit(AuthWidgeDisplay(view: view));
  }
}
