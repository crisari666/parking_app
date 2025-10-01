import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/core/utils/snackbar_service.dart';
import 'package:quantum_parking_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quantum_parking_flutter/features/auth/presentation/bloc/auth_event.dart';
import 'package:quantum_parking_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:quantum_parking_flutter/features/auth/presentation/widgets/email_input.dart';
import 'package:quantum_parking_flutter/features/auth/presentation/widgets/password_input.dart';
import 'package:quantum_parking_flutter/features/config/presentation/bloc/config_bloc.dart';
import 'package:quantum_parking_flutter/features/config/presentation/bloc/config_event.dart';
import 'package:quantum_parking_flutter/features/config/presentation/bloc/config_state.dart';
import 'package:quantum_parking_flutter/features/config/presentation/widgets/update_dialog.dart';
import 'package:quantum_parking_flutter/l10n/app_localizations_context.dart';
import 'package:quantum_parking_flutter/routes/app_router.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.loc;
    
    // On first render, only dispatch LoadAppConfig, chaining the rest via callbacks
    context.read<ConfigBloc>().add(LoadAppConfig(afterRefresh: () {
      context.read<ConfigBloc>().add(CheckAppVersion(afterCheck: () {
        context.read<AuthBloc>().add(CheckAuthStatus());
      }));
    }));
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.login),
      ),
      body: BlocListener<ConfigBloc, ConfigState>(
        listener: (context, state) {
          if (state is UpdateRequired) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => UpdateDialog(
                currentVersion: state.currentVersion,
                minRequiredVersion: state.minRequiredVersion,
                storeUrl: state.storeUrl,
              ),
            );
          }
        },
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              AutoRouter.of(context).replace(const MainRoute());
            } else if (state is AuthError) {
              SnackbarService.instance.showErrorSnackbar(
                context: context,
                message: state.message,
              );
            }
          },
          builder: (context, state) {
            if (state is AuthSuccess) {
              AutoRouter.of(context).replace(const MainRoute());
            }
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            
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
      ),
    );
  }
} 