import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frog/domain/blocs/auth/auth_bloc.dart';
import 'package:frog/presentation/theme/app_theme.dart';
import 'package:frog/presentation/routes/app_router.dart';
import 'package:get_it/get_it.dart';
import '../data/repositories/firebase_frog_repository.dart';
import '../domain/blocs/auth/auth_event.dart';
import '../domain/blocs/frog/frog_bloc.dart';
import '../domain/repositories/frog_repository.dart';

class FrogApp extends StatelessWidget {
  const FrogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<FrogRepository>(
            create: (context) => FirebaseFrogRepository(
              firestore: FirebaseFirestore.instance,
            ),
          ),
          // Інші репозиторії...
        ],
          child:  MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => GetIt.instance<AuthBloc>()..add(CheckAuthStatusEvent()),
        ),
        BlocProvider(
          create: (context) => FrogBloc(
            frogRepository: context.read<FrogRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Frog App',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: AppRouter.splashRoute,
      ),
    ),
    );
  }
}