import 'package:expense_tracker/app_view.dart';
import 'package:expense_tracker/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_repository/expense_repository.dart';

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  const MyApp(this.userRepository, {super.key, required AuthenticationBloc authenticationBloc});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AuthenticationBloc>(
      create: (context) => AuthenticationBloc(
          userRepository: userRepository
      ),


      child: const MyAppView(),
    );
  }
}