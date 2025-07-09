import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:quantum_parking_flutter/core/utils/custom_scroll_behaviour.dart';
import 'package:quantum_parking_flutter/core/utils/snackbar_service.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_bloc.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_event.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_state.dart';
import 'package:quantum_parking_flutter/features/main/presentation/widgets/app_drawer.dart';
import 'package:quantum_parking_flutter/features/main/presentation/widgets/check_in_vehicle.dart';
import 'package:quantum_parking_flutter/features/main/presentation/widgets/check_out_vehicle.dart';
import 'package:quantum_parking_flutter/features/main/presentation/widgets/main_page_app_bar.dart';
import 'package:quantum_parking_flutter/l10n/app_localizations_context.dart';
import 'package:quantum_parking_flutter/routes/app_router.dart';

@RoutePage()
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

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
    // Verify setup when page is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<MainBloc>().add(VerifySetupRequested());
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
    );
  }
} 