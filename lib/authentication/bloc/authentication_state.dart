part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState {
  const AuthenticationState();

  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationFailure extends AuthenticationState {
  final String error;
  const AuthenticationFailure({@required this.error});
  @override
  List<Object> get props => [error];
}

class AuthenticationAuthenticated extends AuthenticationState {}

class AuthenticationUnAuthenticated extends AuthenticationState {}
