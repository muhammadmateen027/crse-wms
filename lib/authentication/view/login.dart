import 'package:crsewms/authentication/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../routes_name.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is AuthenticationFailure) {
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('Authentication Failure')),
                );
              return;
            }
            if (state is DriverAuthenticationAuthenticated) {
              Navigator.of(context).pushReplacementNamed(RoutesName.driverHome);
              return;
            }
            if (state is SiteManagerAuthenticationAuthenticated) {
              Navigator.of(context).pushReplacementNamed(RoutesName.siteManagerHome);
              return;
            }
          },
          builder: (_, state) {
            return Align(
              alignment: const Alignment(0, -1 / 3),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/colas_rails_logo.png',
                      height: 120,
                    ),
                    const SizedBox(height: 32.0),
                    InputField(
                      controller: _emailController,
                      label: 'Email',
                      textInputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16.0),
                    InputField(
                      controller: _passwordController,
                      label: 'Password',
                      obscureText: true,
                    ),
                    const SizedBox(height: 24.0),
                    _loginButton(state),
                    const SizedBox(height: 8.0),
                    // _GoogleLoginButton(),
                    // const SizedBox(height: 4.0),
                    // _SignUpButton(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _loginButton(AuthenticationState state) {
    if (state is AuthenticationLoading) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFff8b54)),
        backgroundColor: Colors.white,
      );
    }
    return RaisedButton(
      key: const Key('loginForm_continue_raisedButton'),
      child: const Text('LOGIN', style: TextStyle(color: Colors.white),),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      color: Color(0xFFff8b54),
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 32.0),
      onPressed: () => _onPressed(),
    );
  }

  void _onPressed() {
    if (_emailController.text?.isEmpty ?? true) {
      _showMessage('Enter email address.', backgroundColor: Color(0xFFff8b54));
      return;
    }
    if (_passwordController.text?.isEmpty ?? true) {
      _showMessage('Enter password.', backgroundColor: Color(0xFFff8b54));
      return;
    }

    context.bloc<AuthenticationBloc>().add(
          FormSubmit(
            email: _emailController.text,
            password: _passwordController.text,
          ),
        );
  }

  _showMessage(String message, {Color backgroundColor = Colors.green}) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: backgroundColor,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
