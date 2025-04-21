import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frog/domain/blocs/auth/auth_bloc.dart';
import 'package:frog/domain/blocs/leaderboard/leaderboard_bloc.dart';
import 'package:frog/domain/repositories/leaderboard_repository.dart';
import 'package:frog/presentation/theme/app_theme.dart';
import 'package:frog/presentation/routes/app_router.dart';
import 'package:get_it/get_it.dart';
import '../data/repositories/firebase_frog_repository.dart';
import '../domain/blocs/auth/auth_event.dart';
import '../domain/blocs/friends/friends_bloc.dart';
import '../domain/blocs/frog/frog_bloc.dart';
import '../domain/blocs/visit/visit_bloc.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/friends_repository.dart';
import '../domain/repositories/frog_repository.dart';
import '../domain/repositories/profile_repository.dart';
import '../domain/repositories/visit_repository.dart';

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
        RepositoryProvider<AuthRepository>(
          create: (_) => GetIt.instance<AuthRepository>(),
        ),
        RepositoryProvider<ProfileRepository>(
          create: (_) => GetIt.instance<ProfileRepository>(),
        ),
        RepositoryProvider<LeaderboardRepository>(
          create: (_) => GetIt.instance<LeaderboardRepository>(),
        ),
        RepositoryProvider<FriendsRepository>(
          create: (_) => GetIt.instance<FriendsRepository>(),
        ),
        RepositoryProvider<VisitRepository>(
          create: (_) => GetIt.instance<VisitRepository>(),
        ),

        // інші провайдери...
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (_) => GetIt.instance<AuthBloc>()..add(CheckAuthStatusEvent()),
          ),
          BlocProvider(
            create: (context) => FrogBloc(
              frogRepository: context.read<FrogRepository>(),
            ),
          ),
          BlocProvider<LeaderboardBloc>(
            create: (_) => GetIt.instance<LeaderboardBloc>(),
          ),
          BlocProvider(
            create: (context) => FriendsBloc(
              friendsRepository: context.read<FriendsRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => VisitBloc(
              visitRepository: context.read<VisitRepository>(), authBloc: context.read<AuthBloc>(),
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