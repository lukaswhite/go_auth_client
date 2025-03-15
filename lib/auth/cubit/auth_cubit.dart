import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:go_auth_client/auth/models/models.dart';
import 'package:go_auth_client/auth/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  
  final AuthRepository _repository;
  
  AuthCubit({
    required AuthRepository repository,
  }): _repository = repository, super(AuthAnonymous()) {
    _repository.auth.listen((result) {
      if(result.isAuthenticated) {
        emit(AuthAuthenticated(user: result.user!));
      } else {
        emit(AuthAnonymous());
      }
    });
  }
}
