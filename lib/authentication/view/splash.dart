import 'package:crsewms/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          // Box decoration takes a gradient
          gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            // Add one stop for each color. Stops should increase from 0 to 1
            stops: [0.1, 0.5, 0.7, 0.9],
            colors: [
              // Colors are easy thanks to Flutter's Colors class.
              const Color(0xFFffa354),
              const Color(0xFFffa354),
              const Color(0xFFff8b54),
              const Color(0xFFff8b54),
            ],
          ),
        ),
        child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
          listener: (_, state) {
            if(state is AuthenticationAuthenticated) {
              Navigator.of(context).pushReplacementNamed('/homePage');
            }

            if(state is AuthenticationUnAuthenticated) {
              Navigator.of(context).pushReplacementNamed('/homePage');
            }
          },
          builder: (_, state) {
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}