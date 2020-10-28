part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {
  const AuthenticationEvent();

  List<Object> get props => [];
}

class AuthenticationStarted extends AuthenticationEvent {}

class FetchUserEvent extends AuthenticationEvent {}
