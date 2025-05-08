import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/printer_setup_bloc.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/printer_setup_event.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/printer_setup_state.dart';
import 'package:quantum_parking_flutter/features/main/presentation/widgets/printer_setup/printer_setup_error_widget.dart';
import 'package:quantum_parking_flutter/features/main/presentation/widgets/printer_setup/printer_setup_success_widget.dart';

@RoutePage()
class PrinterSetupPage extends StatelessWidget {
  const PrinterSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return BlocProvider(
      create: (context) => PrinterSetupBloc()..add(PrinterSetupStarted()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.printerSetup),
        ),
        body: BlocBuilder<PrinterSetupBloc, PrinterSetupState>(
          builder: (context, state) {
            if (state is PrinterSetupLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PrinterSetupError) {
              return PrinterSetupErrorWidget(message: state.message);
            }

            if (state is PrinterSetupSuccess) {
              return PrinterSetupSuccessWidget(
                pairedDevices: state.pairedDevices,
                selectedPrinter: state.selectedPrinter,
                isConnected: state.isConnected,
              );
            }

            return Center(
              child: Text(l10n.pressRefreshToScan),
            );
          },
        ),
      ),
    );
  }
} 