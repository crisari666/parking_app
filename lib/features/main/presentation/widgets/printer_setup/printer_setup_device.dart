import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:quantum_parking_flutter/injection/injection.dart';
import 'package:quantum_parking_flutter/l10n/app_localizations.dart';
import 'package:quantum_parking_flutter/core/utils/snackbar_service.dart';
import 'package:quantum_parking_flutter/features/main/data/repositories/printer_repository.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/printer_setup_bloc.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/printer_setup_event.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/printer_setup_state.dart';

class PrinterSetupDevice extends StatelessWidget {
  const PrinterSetupDevice({super.key});

  Future<void> _setDefaultPrinter(
    BuildContext context,
    String macAddress,
    String name,
  ) async {
    try {
      await getIt<PrinterRepository>().saveStoredPrinter(
        macAddress: macAddress,
        name: name,
      );
      if (context.mounted) {
        SnackbarService.instance.showSuccessSnackbar(
          context: context,
          message: 'Default printer set to: $name',
        );
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarService.instance.showErrorSnackbar(
          context: context,
          message: 'Error setting default printer: $e',
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
                      items: state.pairedDevices.map((BluetoothInfo device) {
                        return DropdownMenuItem<String>(
                          value: device.macAdress,
                          child: Text('${device.name} - ${device.macAdress}'),
                        );
                      }).toList(),
                      onChanged: (String? macAddress) {
                        if (macAddress != null) {
                          context.read<PrinterSetupBloc>().add(
                            PrinterSetupConnectToPrinter(macAddress),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    if (state.isConnected && state.selectedPrinter != null)
                      ElevatedButton.icon(
                        onPressed: () {
                          String name = state.selectedPrinter!;
                          for (final d in state.pairedDevices) {
                            if (d.macAdress == state.selectedPrinter) {
                              name = d.name;
                              break;
                            }
                          }
                          _setDefaultPrinter(
                            context,
                            state.selectedPrinter!,
                            name,
                          );
                        },
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
