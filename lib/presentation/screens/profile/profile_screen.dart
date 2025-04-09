import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frog/domain/blocs/auth/auth_bloc.dart';
import 'package:frog/domain/blocs/auth/auth_state.dart';
import 'package:frog/domain/blocs/auth/auth_event.dart';
import 'package:frog/domain/blocs/profile/profile_bloc.dart';
import 'package:frog/domain/blocs/profile/profile_event.dart';
import 'package:frog/domain/blocs/profile/profile_state.dart';
import 'package:frog/presentation/screens/profile/widgets/avatar.dart';
import 'package:frog/presentation/screens/profile/widgets/editable_text.dart';
import 'package:frog/presentation/screens/profile/widgets/frog_details.dart';
import 'package:frog/presentation/screens/profile/widgets/loading_view.dart';
import 'package:frog/presentation/screens/profile/widgets/error_view.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _frogNameController = TextEditingController();
  bool _isEditingNickname = false;
  bool _isEditingFrogName = false;

  @override
  void dispose() {
    _nicknameController.dispose();
    _frogNameController.dispose();
    super.dispose();
  }

  void _handleLogout() {
    context.read<AuthBloc>().add(LogoutEvent());
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA9C683),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Профіль',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is AuthAuthenticated) {
            context.read<ProfileBloc>().add(LoadProfileEvent(userId: authState.user.id));

            return BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoading || state is ProfileInitial) {
                  return const LoadingView();
                } else if (state is ProfileError) {
                  return ErrorView(
                    message: state.message,
                    onRetry: () => context.read<ProfileBloc>().add(
                      LoadProfileEvent(userId: authState.user.id),
                    ),
                  );
                } else if (state is ProfileLoaded || state is ProfileUpdating) {
                  final user = state is ProfileLoaded ? state.user : (state as ProfileUpdating).user;
                  final frogData = state is ProfileLoaded ? state.frogData : (state as ProfileUpdating).frogData;
                  final isUpdating = state is ProfileUpdating;

                  _nicknameController.text = user.nickname;
                  _frogNameController.text = frogData.frogName;

                  return Stack(
                    children: [
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),
                            const Avatar(),
                            const SizedBox(height: 20),
                            EditableTextField(
                              value: user.nickname,
                              isEditing: _isEditingNickname,
                              controller: _nicknameController,
                              onEdit: () => setState(() => _isEditingNickname = true),
                              onSave: () {
                                context.read<ProfileBloc>().add(
                                  UpdateNicknameEvent(
                                    userId: authState.user.id,
                                    newNickname: _nicknameController.text,
                                  ),
                                );
                                setState(() => _isEditingNickname = false);
                              },
                              textStyle: const TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    blurRadius: 10.0,
                                    color: Colors.black38,
                                    offset: Offset(2.0, 2.0),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 40),
                            FrogDetails(
                              frogData: frogData,
                              frogNameController: _frogNameController,
                              isEditingFrogName: _isEditingFrogName,
                              onEditToggle: () => setState(() => _isEditingFrogName = !_isEditingFrogName),
                              onSaveFrogName: () {
                                context.read<ProfileBloc>().add(
                                  UpdateFrogNameEvent(
                                    userId: authState.user.id,
                                    newFrogName: _frogNameController.text,
                                  ),
                                );
                                // Після оновлення, повторно завантажити профіль
                                context.read<ProfileBloc>().add(
                                  LoadProfileEvent(userId: authState.user.id),
                                );
                                setState(() => _isEditingFrogName = false);
                              },

                            ),
                            const SizedBox(height: 20),
                            TextButton(
                              onPressed: _handleLogout,
                              child: const Text(
                                'Вийти',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isUpdating)
                        Container(
                          color: Colors.black.withOpacity(0.3),
                          child: const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        ),
                    ],
                  );
                }
                return const LoadingView();
              },
            );
          }
          return const LoadingView();
        },
      ),
    );
  }
}
