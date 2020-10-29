part of 'main.dart';

class MyApp extends StatelessWidget {
  final UserRepository userRepository;

  MyApp({Key key, @required this.userRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.black,
      statusBarBrightness: Brightness.light,
    ));
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (_) => AuthenticationBloc(
            userRepositoryInterface: userRepository,
          )..add(AuthenticationStarted()),
        ),

        BlocProvider<OrderBloc>(
          create: (_) => OrderBloc(
            userRepositoryInterface: userRepository,
          )),
      ],
      child: MaterialApp(
        title: 'CRSE-WMS',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: RoutesName.initial,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
