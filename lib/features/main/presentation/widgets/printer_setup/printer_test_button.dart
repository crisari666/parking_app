import 'package:flutter/material.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:logger/logger.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';

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

      // Create a generator with default profile
      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm80, profile);
      List<int> bytes = [];

      // Print header
      bytes += generator.text('TEST QR CODE',
          styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          ));
      bytes += generator.hr();

      // Print QR code
      bytes += generator.qrcode('ABC123',
          size: QRSize.size6,
          cor: QRCorrection.M);

      // Print footer
      bytes += generator.hr();
      bytes += generator.text('Thank you!',
          styles: const PosStyles(align: PosAlign.center));

      // Cut paper
      bytes += generator.cut();

      // Send to printer
      await PrintBluetoothThermal.writeBytes(bytes);

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
