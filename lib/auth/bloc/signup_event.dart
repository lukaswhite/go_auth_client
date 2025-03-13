part of 'signup_bloc.dart';

sealed class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class SignupSubmit extends SignupEvent {

  final SignupRequest request;

  const SignupSubmit({
    required this.request,
  });

  @override
  List<Object> get props => [request,];
}