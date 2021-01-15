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

    Map<int, Color> primaryColor = {
      50: Color.fromRGBO(227, 230, 255, 1),
      100: Color.fromRGBO(185, 192, 255, 1),
      200: Color.fromRGBO(138, 150, 255, 1),
      300: Color.fromRGBO(91, 107, 255, 1),
      400: Color.fromRGBO(56, 76, 255, 1),
      500: Color.fromRGBO(21, 44, 255, 1),
      600: Color.fromRGBO(18, 39, 255, 1),
      700: Color.fromRGBO(15, 33, 255, 1),
      800: Color.fromRGBO(12, 27, 255, 1),
      900: Color.fromRGBO(6, 16, 255, 1),
    };

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (_) => AuthenticationBloc(
            userRepositoryInterface: userRepository,
          )..add(AuthenticationStarted()),
        ),
        BlocProvider<OrderBloc>(
          create: (_) => OrderBloc(userRepositoryInterface: userRepository),
        ),
        BlocProvider<MrfListBloc>(
          create: (_) => MrfListBloc(
            userRepositoryInterface: userRepository,
          )..add(FetchMRFs(isApprovedMrf: false)),
        ),
        BlocProvider<MrfCrudBloc>(
          create: (_) => MrfCrudBloc(userRepositoryInterface: userRepository),
        ),
      ],
      child: MaterialApp(
        title: 'CRSE-WMS',
        theme: ThemeData(
          primarySwatch: MaterialColor(0xFFff8b54, primaryColor),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: RoutesName.initial,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
