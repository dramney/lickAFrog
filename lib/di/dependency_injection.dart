import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frog/domain/repositories/auth_repository.dart';
import 'package:frog/data/repositories/auth_repository_impl.dart';
import 'package:frog/domain/blocs/auth/auth_bloc.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void initDependencies() {
  // Firebase
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      getIt<FirebaseAuth>(),
      getIt<FirebaseFirestore>(),
    ),
  );

  // BLoCs
  getIt.registerFactory<AuthBloc>(
        () => AuthBloc(getIt<AuthRepository>()),
  );
}