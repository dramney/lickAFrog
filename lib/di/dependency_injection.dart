import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frog/domain/blocs/friends/friends_bloc.dart';
import 'package:frog/domain/repositories/auth_repository.dart';
import 'package:frog/data/repositories/auth_repository_impl.dart';
import 'package:frog/data/repositories/profile_repository_impl.dart';
import 'package:frog/data/repositories/firebase_frog_repository.dart';
import 'package:frog/data/repositories/leaderboard_repository_impl.dart';
import 'package:frog/domain/repositories/friends_repository.dart';
import 'package:frog/domain/repositories/profile_repository.dart';
import 'package:frog/domain/repositories/frog_repository.dart';
import 'package:frog/domain/repositories/leaderboard_repository.dart';
import 'package:frog/domain/blocs/auth/auth_bloc.dart';
import 'package:frog/domain/blocs/leaderboard/leaderboard_bloc.dart';
import 'package:frog/domain/blocs/profile/profile_bloc.dart';
import 'package:get_it/get_it.dart';

import '../data/repositories/friends_repository_impl.dart';

final getIt = GetIt.instance;

void initDependencies() {
  // Firebase
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // Repositories
  // Реєстрація AuthRepository
  getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      getIt<FirebaseAuth>(),
      getIt<FirebaseFirestore>(),
    ),
  );

  // Реєстрація ProfileRepository з правильною передачею параметрів
  getIt.registerLazySingleton<ProfileRepository>(
        () => FirebaseProfileRepository(
      firestore: getIt<FirebaseFirestore>(),  // Потрібно передавати firestore
    ),
  );

  // Реєстрація FrogRepository
  getIt.registerLazySingleton<FrogRepository>(
        () => FirebaseFrogRepository(
      firestore: getIt<FirebaseFirestore>(), // Передаємо firestore
    ),
  );

  // Реєстрація LeaderboardRepository
  getIt.registerLazySingleton<LeaderboardRepository>(
        () => LeaderboardRepositoryImpl(
          firestore: getIt<FirebaseFirestore>(),
        ),
  );

  getIt.registerLazySingleton<FriendsRepository>(
        () => FriendsRepositoryImpl(
      firestore: getIt<FirebaseFirestore>(),
    ),
  );

  // BLoCs
  // Реєстрація AuthBloc
  getIt.registerFactory<AuthBloc>(
        () => AuthBloc(getIt<AuthRepository>()),
  );

  // Реєстрація LeaderboardBloc
  getIt.registerFactory<LeaderboardBloc>(
        () => LeaderboardBloc(getIt<LeaderboardRepository>()),
  );

  getIt.registerFactory<FriendsBloc>(
        () => FriendsBloc(friendsRepository: getIt<FriendsRepository>()),
  );

  // Реєстрація ProfileBloc
  getIt.registerFactory<ProfileBloc>(
        () => ProfileBloc(
      authRepository: getIt<AuthRepository>(),   // Реєструємо AuthRepository
      frogRepository: getIt<FrogRepository>(),   // Реєструємо FrogRepository
      profileRepository: getIt<ProfileRepository>(), // Реєструємо ProfileRepository
    ),
  );
}
