import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:artoku/bloc/auth/auth_bloc.dart';
import 'package:artoku/global_variable.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc()..add(CheckLoginStatusEvent()),
      child: const SplashView(),
    );
  }
}

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.pushReplacementNamed(context, 'userPage');
        } else if (state is UnAuthenticated) {
          Navigator.pushReplacementNamed(context, 'intro');
        }
      },
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(
              horizontal: GlobalVariable.deviceWidth(context) * 0.1),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).secondaryHeaderColor,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.png',
                width: GlobalVariable.deviceWidth(context) * 0.80,
                height: GlobalVariable.deviceHeight(context) * 0.50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
