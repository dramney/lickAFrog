import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:frog/firebase_options.dart';
import 'package:frog/presentation/app.dart';
import 'package:frog/di/dependency_injection.dart';

final GetIt getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Set up dependency injection
  initDependencies();

  runApp(const FrogApp());
}