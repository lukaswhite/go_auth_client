import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:go_auth_client/auth/http/requests/login_request.dart';
import 'package:go_auth_client/auth/auth_repository.dart';
import 'package:go_auth_client/http/responses/response.dart';
import 'package:go_auth_client/auth/models/models.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  
  final AuthRepository _authRepository;
  
  LoginBloc({
    required AuthRepository authRepository,
  }): _authRepository = authRepository, super(LoginInitial()) {
    on<LoginSubmit>((event, emit) async {
      emit(LoginSubmitting(request: event.request,));
      final result = await _authRepository.login(event.request);
      result.fold(
        (user) => emit(LoginComplete(user: user)),
        (response) => emit(LoginError(request: event.request, response: response))
      );
    });
  }
}
