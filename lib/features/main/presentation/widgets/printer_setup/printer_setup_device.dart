import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/printer_setup_bloc.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/printer_setup_event.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/printer_setup_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrinterSetupDevice extends StatelessWidget {
  const PrinterSetupDevice({super.key});

  Future<void> _setDefaultPrinter(BuildContext context, String printerName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('default_printer', printerName);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Default printer set to: $printerName')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error setting default printer: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return BlocBuilder<PrinterSetupBloc, PrinterSetupState>(
      builder: (context, state) {
        if (state is PrinterSetupSuccess) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (state.pairedDevices.isEmpty)
                Center(
                  child: Text(l10n.noPairedDevices),
                )
              else
                Column(
                  children: [
                    DropdownButton<String>(
                      value: state.selectedPrinter,
                      hint: Text(l10n.selectPrinter),
                      isExpanded: true,
                      items: state.pairedDevices.map((String device) {
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
                    if (state.isConnected && state.selectedPrinter != null)
                      ElevatedButton.icon(
                        onPressed: () => _setDefaultPrinter(
                          context,
                          state.selectedPrinter!,
                        ),
                        icon: const Icon(Icons.save),
                        label: const Text('Set as Default Printer'),
                      ),
                  ],
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
                if (state.isConnected)
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<PrinterSetupBloc>().add(
                        PrinterSetupDisconnect(),
                      );
                    },
                    icon: const Icon(Icons.link_off),
                    label: Text(l10n.disconnectPrinter),
                  ),
            ],
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
