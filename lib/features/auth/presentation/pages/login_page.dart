import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quantum_parking_flutter/features/auth/presentation/widgets/email_input.dart';
import 'package:quantum_parking_flutter/features/auth/presentation/widgets/password_input.dart';
import 'package:quantum_parking_flutter/l10n/app_localizations_context.dart';
import 'package:quantum_parking_flutter/routes/app_router.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.loc;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.login),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            AutoRouter.of(context).push(const MainRoute());
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const EmailInput(),
                const SizedBox(height: 16),
                const PasswordInput(),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(LoginRequested());
                  },
                  child: Text(l10n.login),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    AutoRouter.of(context).push(const RegisterRoute());
                  },
                  child: Text(l10n.dontHaveAccountRegister),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} 