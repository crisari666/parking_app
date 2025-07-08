import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:quantum_parking_flutter/core/utils/custom_scroll_behaviour.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_bloc.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_event.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_state.dart';
import 'package:quantum_parking_flutter/features/main/presentation/widgets/app_drawer.dart';
import 'package:quantum_parking_flutter/features/main/presentation/widgets/check_in_vehicle.dart';
import 'package:quantum_parking_flutter/features/main/presentation/widgets/check_out_vehicle.dart';
import 'package:quantum_parking_flutter/features/main/presentation/widgets/main_page_app_bar.dart';
import 'package:quantum_parking_flutter/features/main/presentation/widgets/printer_setup/printer_test_button_device.dart';
import 'package:quantum_parking_flutter/l10n/app_localizations_context.dart';
import 'package:quantum_parking_flutter/routes/app_router.dart';

@RoutePage()
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Verify setup when page is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MainBloc>().add(VerifySetupRequested());
    });

    return Scaffold(
      appBar: const MainPageAppBar(),
      drawer: const AppDrawer(),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehaviour(),
        child: SingleChildScrollView(
          child: BlocConsumer<MainBloc, MainState>(
            listener: (context, state) {
              if(state.message != null) {
               Future.delayed(const Duration(milliseconds: 100), () {
                  context.read<MainBloc>().add(ClearMessage());
                }); 
              }
              if (state.message != null && !state.isCheckin && !state.isCheckout) {
                final currentMessage = state.message!;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(currentMessage),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 3),
                    action: SnackBarAction(
                      label: 'Dismiss',
                      onPressed: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        context.read<MainBloc>().add(ClearMessage());
                      },
                    ),
                  ),
                );
                
                // Clear message after snackbar is shown to prevent multiple snackbars
                
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

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const CheckInVehicle(),
                    const SizedBox(height: 16),
                    const CheckOutVehicle(),
                    const SizedBox(height: 16),
                    PrinterTestButtonDevice(),
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