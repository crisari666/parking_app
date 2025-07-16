import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:quantum_parking_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quantum_parking_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:quantum_parking_flutter/routes/app_router.dart';

class UsersDrawerOption extends StatelessWidget {
  const UsersDrawerOption({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // Check if user has admin or user role
        final canAccessUsers = state.userRole == 'admin' || state.userRole == 'user';
        
        if (!canAccessUsers) {
          return const SizedBox.shrink(); // Don't show the option
        }

        return ListTile(
          leading: const Icon(Icons.people),
          title: const Text('Users'),
          onTap: () {
            AutoRouter.of(context).push(const UserListRoute());
            Navigator.pop(context); // Close the drawer
          },
        );
      },
    );
  }
} 