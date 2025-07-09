import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:quantum_parking_flutter/core/utils/snackbar_service.dart';
import 'package:quantum_parking_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quantum_parking_flutter/features/auth/presentation/bloc/auth_event.dart';
import 'package:quantum_parking_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:quantum_parking_flutter/routes/app_router.dart';

@RoutePage()
class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(LogoutRequested());
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          // Navigate to login page when logout is successful
          context.router.replace(const LoginRoute());
        } else if (state is AuthError) {
          SnackbarService.instance.showErrorSnackbar(
            context: context,
            message: state.message,
          );
        }
      },
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
