import 'package:flutter/material.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:logger/logger.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrinterTestButton extends StatelessWidget {
  final _logger = Logger();

  PrinterTestButton({super.key});

  Future<void> _printTestQRCode(BuildContext context) async {
    try {
      final bool isConnected = await PrintBluetoothThermal.connectionStatus;
      
      if (!isConnected) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please connect to a printer first')),
          );
        }
        return;
      }

      // Print header
      await PrintBluetoothThermal.writeString(
        printText: PrintTextSize(
          size: 2,
          text: 'TEST QR CODE\n',
        ),
      );

      // Print QR code data
      await PrintBluetoothThermal.writeString(
        printText: PrintTextSize(
          size: 1,
          text: 'ABC123\n',
        ),
      );

      // Print footer
      await PrintBluetoothThermal.writeString(
        printText: PrintTextSize(
          size: 1,
          text: '\nThank you!\n',
        ),
      );

      // Cut paper
      await PrintBluetoothThermal.writeString(
        printText: PrintTextSize(
          size: 1,
          text: '\n\n\n',
        ),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Test QR code printed successfully')),
        );
      }
    } catch (e) {
      _logger.e('Error printing test QR code: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error printing: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return ElevatedButton.icon(
      onPressed: () => _printTestQRCode(context),
      icon: const Icon(Icons.qr_code),
      label: const Text('Print Test QR Code'),
    );
  }
}
