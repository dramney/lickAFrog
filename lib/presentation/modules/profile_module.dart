import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:frog/domain/repositories/auth_repository.dart';
import 'package:frog/domain/repositories/frog_repository.dart';
import 'package:frog/domain/repositories/profile_repository.dart';
import 'package:frog/data/repositories/profile_repository_impl.dart';
import 'package:frog/domain/blocs/profile/profile_bloc.dart';

import '../screens/profile/profile_screen.dart';


class ProfileModule extends StatelessWidget {
  const ProfileModule({super.key});

  @override
  Widget build(BuildContext context) {
    // Reuse existing repositories
    final authRepository = context.read<AuthRepository>();
    final frogRepository = context.read<FrogRepository>();

    return RepositoryProvider(
      create: (context) => FirebaseProfileRepository(),
      child: BlocProvider(
        create: (context) => ProfileBloc(
          authRepository: authRepository,
          frogRepository: frogRepository,
          profileRepository: context.read<ProfileRepository>(),
        ),
        child: const ProfileScreen(),
      ),
    );
  }
}