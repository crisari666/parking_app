import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'dart:async';
import 'package:quantum_parking_flutter/core/utils/custom_scroll_behaviour.dart';
import 'package:quantum_parking_flutter/core/utils/snackbar_service.dart';
import 'package:quantum_parking_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quantum_parking_flutter/features/auth/presentation/bloc/auth_event.dart';
import 'package:quantum_parking_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_bloc.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_event.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_state.dart';
import 'package:quantum_parking_flutter/features/main/presentation/widgets/app_drawer.dart';
import 'package:quantum_parking_flutter/features/main/presentation/widgets/check_in_vehicle.dart';
import 'package:quantum_parking_flutter/features/main/presentation/widgets/check_out_vehicle.dart';
import 'package:quantum_parking_flutter/features/main/presentation/widgets/main_page_app_bar.dart';
import 'package:quantum_parking_flutter/features/main/presentation/widgets/printer_connection_indicator.dart';
import 'package:quantum_parking_flutter/l10n/app_localizations_context.dart';
import 'package:quantum_parking_flutter/routes/app_router.dart';

@RoutePage()
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  Timer? _sessionValidationTimer;

  void _showSnackbarBasedOnMessageType(BuildContext context, MainState state) {
    if (state.message == null) return;
    
    final message = state.message!;
    final messageType = state.messageType;
    
    // Auto-clear message after 4 seconds to prevent stale messages
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted && context.mounted) {
        context.read<MainBloc>().add(ClearMessage());
      }
    });
    
    switch (messageType) {
      case MessageType.success:
        SnackbarService.instance.showSuccessSnackbar(
          context: context,
          message: message,
          onDismiss: () {
            if (mounted && context.mounted) {
              context.read<MainBloc>().add(ClearMessage());
            }
          },
        );
        break;
      case MessageType.error:
        SnackbarService.instance.showErrorSnackbar(
          context: context,
          message: message,
          onDismiss: () {
            if (mounted && context.mounted) {
              context.read<MainBloc>().add(ClearMessage());
            }
          },
        );
        break;
      case MessageType.warning:
        SnackbarService.instance.showWarningSnackbar(
          context: context,
          message: message,
          onDismiss: () {
            if (mounted && context.mounted) {
              context.read<MainBloc>().add(ClearMessage());
            }
          },
        );
        break;
      case MessageType.info:
        SnackbarService.instance.showInfoSnackbar(
          context: context,
          message: message,
          onDismiss: () {
            if (mounted && context.mounted) {
              context.read<MainBloc>().add(ClearMessage());
            }
          },
        );
        break;
      default:
        // Default to info for messages without specific type
        SnackbarService.instance.showInfoSnackbar(
          context: context,
          message: message,
          onDismiss: () {
            if (mounted && context.mounted) {
              context.read<MainBloc>().add(ClearMessage());
            }
          },
        );
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Verify setup when page is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<MainBloc>().add(VerifySetupRequested());
        // Perform initial printer hardware check
        _performPrinterHardwareCheck();
        // Validate current session
        _validateCurrentSession();
        // Start periodic session validation (every 5 minutes)
        _startPeriodicSessionValidation();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _sessionValidationTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Validate session when app comes back to foreground
      _validateCurrentSession();
    }
  }

  void _performPrinterHardwareCheck() {
    // This will trigger a hardware check by attempting to feed paper
    // The printer repository will handle the actual hardware communication
    context.read<MainBloc>().add(CheckPrinterConnectionStatus());
  }

  void _validateCurrentSession() {
    // Check auth status first to load user info, then validate session
    context.read<AuthBloc>().add(CheckAuthStatus());
    context.read<AuthBloc>().add(ValidateSession());
  }

  void _startPeriodicSessionValidation() {
    // Validate session every 5 minutes
    _sessionValidationTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) {
        if (mounted) {
          _validateCurrentSession();
        }
      },
    );
  }

  void _validateSessionOnUserInteraction() {
    // Validate session when user interacts with the app
    // This provides an additional layer of security
    _validateCurrentSession();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, authState) {
        if (authState is AuthError) {
          // Redirect to login page when auth error occurs
          context.router.replace(const LoginRoute());
        }
      },
      child: GestureDetector(
        onTapDown: (_) => _validateSessionOnUserInteraction(),
        child: Scaffold(
          appBar: const MainPageAppBar(),
          drawer: const AppDrawer(),
          body: ScrollConfiguration(
            behavior: NoGlowScrollBehaviour(),
            child: SingleChildScrollView(
              child: BlocConsumer<MainBloc, MainState>(
                listener: (context, state) {
                  // Handle messages with centralized snackbar service
                  if (state.message != null) {
                    _showSnackbarBasedOnMessageType(context, state);
                  } else if (state.isSetupRequired) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: Text(context.loc.setupRequired),
                          content: Text(context.loc.completeInitialSetup),
                          actions: <Widget>[
                            TextButton(
                              child: Text(context.loc.goToSetup),
                              onPressed: () {
                                Navigator.of(dialogContext).pop(); // Close dialog
                                context.router.push(const SetupRoute()); // Navigate to setup
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: PrinterConnectionIndicator(),
                        ),
                        SizedBox(height: 16),
                        CheckInVehicle(),
                        SizedBox(height: 16),
                        CheckOutVehicle(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
} 