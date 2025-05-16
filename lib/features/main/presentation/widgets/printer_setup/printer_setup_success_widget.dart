import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/printer_setup_bloc.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/printer_setup_event.dart';
import 'package:quantum_parking_flutter/features/main/presentation/widgets/printer_setup/printer_test_button.dart';



class PrinterSetupSuccessWidget extends StatelessWidget {
  final List<String> pairedDevices;
  final String? selectedPrinter;
  final bool isConnected;

  const PrinterSetupSuccessWidget({
    super.key,
    required this.pairedDevices,
    this.selectedPrinter,
    this.isConnected = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (pairedDevices.isEmpty)
            Center(
              child: Text(l10n.noPairedDevices),
            )
          else
            DropdownButton<String>(
              value: selectedPrinter,
              hint: Text(l10n.selectPrinter),
              isExpanded: true,
              items: pairedDevices.map((String device) {
                return DropdownMenuItem<String>(
                  value: device,
                  child: Text(device),
                );
              }).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  context.read<PrinterSetupBloc>().add(
                    PrinterSetupConnectToPrinter(value),
                  );
                }
              },
            ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              context.read<PrinterSetupBloc>().add(
                PrinterSetupGetPairedDevices(),
              );
            },
            icon: const Icon(Icons.refresh),
            label: Text(l10n.refreshDevices),
          ),
          const SizedBox(height: 16),
          if (isConnected)
            Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<PrinterSetupBloc>().add(
                      PrinterSetupDisconnect(),
                    );
                  },
                  icon: const Icon(Icons.link_off),
                  label: Text(l10n.disconnectPrinter),
                ),
                const SizedBox(height: 16),
                PrinterTestButton(),
              ],
            ),
        ],
      ),
    );
  }
} 