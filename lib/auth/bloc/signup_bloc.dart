import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:go_auth_client/auth/http/requests/signup_request.dart';
import 'package:go_auth_client/auth/auth_repository.dart';
import 'package:go_auth_client/http/responses/response.dart';
import 'package:go_auth_client/auth/models/models.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {

  final AuthRepository _authRepository;

  SignupBloc({
    required AuthRepository authRepository,
  }): _authRepository = authRepository, super(SignupInitial()) {
    on<SignupSubmit>((event, emit) async {
      emit(SignupSubmitting(request: event.request,));
      final result = await _authRepository.signup(event.request);

      result.fold(
        (user) => emit(SignupComplete(user: user)),
        (response) => emit(SignupError(request: event.request, response: response))
      );

    });
  }
}
