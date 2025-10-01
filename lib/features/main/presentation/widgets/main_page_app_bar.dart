import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:quantum_parking_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quantum_parking_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:quantum_parking_flutter/routes/app_router.dart';

class MainPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainPageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Quantum Parking'),
      actions: [
        IconButton(
          icon: const Icon(Icons.history),
          onPressed: () {
            AutoRouter.of(context).push(const RecordsRoute());
          },
        ),
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            // Check if user has admin or user role
            final canAccessClosure = state.userRole == 'admin' || state.userRole == 'user';
            if (!canAccessClosure) {
              return const SizedBox.shrink(); // Don't show the button
            }
            return IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () {
                AutoRouter.of(context).push(const ClosureRoute());
              },
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 