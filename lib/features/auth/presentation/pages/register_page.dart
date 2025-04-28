import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quantum_parking_flutter/routes/app_router.dart';
import 'package:quantum_parking_flutter/l10n/app_localizations_context.dart';

@RoutePage()
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.register),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            AutoRouter.of(context).push(const SetupRoute());
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
                TextField(
                  decoration: InputDecoration(
                    labelText: context.loc.email,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    context.read<AuthBloc>().add(EmailChanged(value));
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: context.loc.password,
                    border: const OutlineInputBorder(),
                  ),
                  obscureText: true,
                  onChanged: (value) {
                    context.read<AuthBloc>().add(PasswordChanged(value));
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(RegisterRequested());
                  },
                  child: Text(context.loc.register),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(context.loc.alreadyHaveAccountLogin),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} 