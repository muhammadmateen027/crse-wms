import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meta/meta.dart';
import '../../repository/repository.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    @required this.userRepositoryInterface,
  })
      : assert(userRepositoryInterface != null),
        super(AuthenticationInitial());

  final UserRepositoryInterface userRepositoryInterface;

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event,) async* {
    if (event is FetchUserEvent) {
      yield* _fetchUserInfoEventToState(event);
      return;
    }
    if (event is AuthenticationStarted) {
      yield* _authenticationToState(event);
      return;
    }
    if (event is FormSubmit) {
      yield* _loginToState(event);
      return;
    }

     if (event is UnAuthenticate) {
       await userRepositoryInterface.deleteToken();
       yield AuthenticationUnAuthenticated();
     }
  }

  Stream<AuthenticationState> _authenticationToState(
      AuthenticationStarted event) async* {
    yield AuthenticationLoading();
    bool hasToken =
    await userRepositoryInterface.hasToken(DotEnv().env['TOKEN']);
    if (hasToken) {
      String user = await userRepositoryInterface.retrieveToken('USER_ROLE');
      // if (user == 'driver') {
      //   yield DriverAuthenticationAuthenticated();
      //   return;
      // }

      yield SiteManagerAuthenticationAuthenticated();
      return;
    }
    yield AuthenticationUnAuthenticated();
    return;
  }

  Stream<AuthenticationState> _fetchUserInfoEventToState(
      FetchUserEvent event) async* {}

  Stream<AuthenticationState> _loginToState(FormSubmit event) async* {
    yield AuthenticationLoading();
    Response response;

    try {
      response = await userRepositoryInterface.login(
        event.email,
        event.password,
      );
    } on ApiException catch (error) {
      yield AuthenticationFailure(error: error.toString());
      return;
    }

    await userRepositoryInterface.persistToken(
      DotEnv().env['TOKEN'],
      '${event.email}::${event.password}',
    );

    await userRepositoryInterface.persistToken(
      'USER_ROLE',
      response.data['user_role'].toString(),
    );

    yield SiteManagerAuthenticationAuthenticated();
    return;

    if (response.data['user_role'] == 'driver') {
      yield DriverAuthenticationAuthenticated();
      return;
    }

    yield SiteManagerAuthenticationAuthenticated();
    return;
  }
}
