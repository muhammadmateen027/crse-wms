import 'package:crsewms/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../routes_name.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
          listener: (_, state) {
            if (state is DriverAuthenticationAuthenticated) {
              Navigator.of(context).pushReplacementNamed(RoutesName.driverHome);
            }

            if (state is AuthenticationUnAuthenticated) {
              Navigator.of(context).pushReplacementNamed(RoutesName.login);
            }

            if (state is SiteManagerAuthenticationAuthenticated) {
              Navigator.of(context).pushReplacementNamed(RoutesName.siteManagerHome);
            }
          },
          builder: (_, state) {
            if (state is AuthenticationLoading) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/colas_rails_logo.png'),
                  SizedBox(height: 32),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFff8b54)),
                    backgroundColor: Colors.white,
                  ),
                ],
              );
            }

            return Image.asset('assets/images/colas_rails_logo.png');
          },
        ),
      ),
    );
  }
}
