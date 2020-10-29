import 'package:crsewms/authentication/authentication.dart';
import 'package:crsewms/home/home.dart';
import 'package:crsewms/route_generator.dart';
import 'package:crsewms/routes_name.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'bloc_observer.dart';
import 'repository/repository.dart';

part 'crse.dart';

void main() async {
  await DotEnv().load('.env');
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  final _dio = new Dio();
  _dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

  final userRepository = UserRepository(
    dataProviderClient: DataProviderClient(dio: _dio),
    storage: FlutterSecureStorage(),
  );

  SystemChrome.setPreferredOrientations(
    <DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ],
  ).then((_) => runApp(MyApp(userRepository: userRepository)));
}
