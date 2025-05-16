import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:printing/printing.dart';
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

    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {
        if (state is MainError && !state.isCheckin && !state.isCheckout) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is SetupRequired) {
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
        if (state is MainLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return Scaffold(
          appBar: const MainPageAppBar(),
          drawer: const AppDrawer(),
          body: ScrollConfiguration(
            behavior: NoGlowScrollBehaviour(),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const CheckInVehicle(),
                    const SizedBox(height: 16),
                    const CheckOutVehicle(),
                    PrinterTestButtonDevice(defaultPrinter: const Printer(
                      url: 'bt://00:11:22:33:44:55',  // Bluetooth MAC address format
                      name: 'POSPrinter',
                      isDefault: true,
                      model: 'POSPrinter',
                    ),),
                    // PrintButton(
                    //   text: 'Hello, World!',
                    //   qrCodeData: '1234567890',
                    // ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
} 