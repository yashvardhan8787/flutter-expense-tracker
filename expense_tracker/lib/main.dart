import 'package:bloc/bloc.dart';
import 'package:expense_tracker/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import "package:expense_repository/expense_repository.dart";
import 'blocs/authentication_bloc/authentication_bloc.dart';
import "simpleBlocObserver.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  final userRepository = FirebaseUserRepo();
  final authenticationBloc = AuthenticationBloc(userRepository: userRepository)
    ..add(AuthenticationStarted()); // Trigger splash screen

  runApp(
    MyApp(userRepository, authenticationBloc: authenticationBloc),
  );
}
