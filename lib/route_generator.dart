import 'package:crsewms/authentication/authentication.dart';
import 'package:crsewms/home/home.dart';
import 'package:crsewms/routes_name.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings setting) {
    final args = setting.arguments;
    switch (setting.name) {
      case RoutesName.initial:
        return MaterialPageRoute(builder: (_) => Splash());
        break;

      case RoutesName.login:
        return MaterialPageRoute(
          builder: (_) => LoginForm(),
        );
        break;

      case RoutesName.home:
        return MaterialPageRoute(
          builder: (_) => OrderList(),
        );
        break;

      case RoutesName.detail:
        return MaterialPageRoute(
          builder: (_) => OrderDetailPage(arguments: args),
        );
        break;
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
