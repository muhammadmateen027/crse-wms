part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {
  const AuthenticationEvent();

  List<Object> get props => [];
}

class AuthenticationStarted extends AuthenticationEvent {}

class UnAuthenticate extends AuthenticationEvent {}

class FetchUserEvent extends AuthenticationEvent {}

class FormSubmit extends AuthenticationEvent {
  final String email;
  final String password;
  const FormSubmit({@required this.email, @required this.password});
  @override
  List<Object> get props => [email, password];
}
