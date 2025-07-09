import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr/qr.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:logger/logger.dart';
import 'package:quantum_parking_flutter/core/utils/snackbar_service.dart';

class PrinterTestButtonDevice extends StatelessWidget {
  final _logger = Logger();
  // You can set this to your default printer
  final Printer? defaultPrinter;

  PrinterTestButtonDevice({super.key, this.defaultPrinter});

  Future<Uint8List> _generateQrCodeImage(String data) async {
    final qrCode = QrCode.fromData(
      data: data,
      errorCorrectLevel: QrErrorCorrectLevel.M,
    );

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final painter = QrPainter.withQr(
      qr: qrCode,
      color: const Color(0xFF000000),
      gapless: true,
    );

    const size = 200.0;
    painter.paint(canvas, const Size(size, size));

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<void> _printTestQRCode(BuildContext context) async {
    try {
      final qrBytes = await _generateQrCodeImage('ABC123');

      final pdf = pw.Document();

      final printers = await Printing.listPrinters();
      _logger.d('Printers: $printers');

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.roll80,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'TEST QR CODE',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Image(
                  pw.MemoryImage(qrBytes),
                  width: 200,
                  height: 200,
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'ABC123',
                  style: const pw.TextStyle(fontSize: 16),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Thank you!',
                  style: const pw.TextStyle(fontSize: 16),
                ),
              ],
            );
          },
        ),
      );

      final pdfBytes = await pdf.save();

      if (defaultPrinter != null) {
        // Try silent printing if printer is provided
        try {
          await Printing.directPrintPdf(
            printer: defaultPrinter!,
            onLayout: (format) async => pdfBytes,
          );
          
          if (context.mounted) {
            SnackbarService.instance.showSuccessSnackbar(
              context: context,
              message: 'Test QR code printed successfully',
            );
          }
        } catch (e) {
          _logger.e('Error in silent printing: $e');
          // Fallback to normal printing if silent printing fails
          await Printing.layoutPdf(
            onLayout: (format) async => pdfBytes,
          );
        }
      } else {
        // Use normal printing if no printer is provided
        await Printing.layoutPdf(
          onLayout: (format) async => pdfBytes,
        );
      }
    } catch (e) {
      _logger.e('Error printing test QR code: $e');
      if (context.mounted) {
        SnackbarService.instance.showErrorSnackbar(
          context: context,
          message: 'Error printing: $e',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {    
    return ElevatedButton.icon(
      onPressed: () => _printTestQRCode(context),
      icon: const Icon(Icons.qr_code),
      label: const Text('Print Test QR Code'),
    );
  }
}
