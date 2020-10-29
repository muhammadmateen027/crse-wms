import 'package:bloc/bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meta/meta.dart';
import '../../repository/repository.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    @required this.userRepositoryInterface,
  })  : assert(userRepositoryInterface != null),
        super(AuthenticationInitial());

  final UserRepositoryInterface userRepositoryInterface;

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is FetchUserEvent) {
      yield* _fetchUserInfoEventToState(event);
    }
    if (event is AuthenticationStarted) {
      yield* _authenticationToState(event);
    }
  }

  Stream<AuthenticationState> _authenticationToState(
      AuthenticationStarted event) async* {
    bool hasToken = await userRepositoryInterface.hasToken(DotEnv().env['TOKEN']);
    if (hasToken) {
      yield AuthenticationAuthenticated();
      return;
    }
    yield AuthenticationUnAuthenticated();
    return;
  }

  Stream<AuthenticationState> _fetchUserInfoEventToState(
      FetchUserEvent event) async* {}
}
