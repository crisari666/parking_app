import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:quantum_parking_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quantum_parking_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:quantum_parking_flutter/routes/app_router.dart';

class UserMembershipDrawerOption extends StatelessWidget {
  const UserMembershipDrawerOption({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // Check if user has admin or user role
        final canAccessUserMemberships = state.userRole == 'admin' || state.userRole == 'user';
        
        if (!canAccessUserMemberships) {
          return const SizedBox.shrink(); // Don't show the option
        }

        return ListTile(
          leading: const Icon(Icons.card_membership),
          title: const Text('User Memberships'),
          onTap: () {
            AutoRouter.of(context).push(const UserMembershipRoute());
            Navigator.pop(context); // Close the drawer
          },
        );
      },
    );
  }
} 