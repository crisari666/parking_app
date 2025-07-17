import 'dart:async';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:logger/logger.dart';
import 'package:quantum_parking_flutter/core/utils/date_time_service.dart';
import 'package:quantum_parking_flutter/core/utils/date_time_extensions.dart';
import 'package:quantum_parking_flutter/features/setup/data/models/business_setup_model.dart';
import 'package:quantum_parking_flutter/features/main/data/models/active_vehicle_log_model.dart';

enum TicketType {
  checkIn,
  checkOut,
  record,
  receipt,
}

class TicketPrinterService {
  static final TicketPrinterService _instance = TicketPrinterService._internal();
  factory TicketPrinterService() => _instance;
  TicketPrinterService._internal();

  final Logger _logger = Logger();
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(seconds: 2);

  /// Print a check-in ticket with QR code
  Future<bool> printCheckInTicket({
    required String plateNumber,
    required BusinessSetupModel businessSetup,
    DateTime? checkInTime,
    String? vehicleType,
  }) async {
    return _printWithRetry(() async {
      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm80, profile);
      List<int> bytes = [];

      // Business header
      bytes += _generateBusinessHeader(generator, businessSetup);
      
      // Check-in header
      bytes += generator.text('ENTRADA DE VEHICULO',
          styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ));
      
      bytes += generator.emptyLines(1);

      // Vehicle details
      bytes += generator.text('PLACA: ${plateNumber.toUpperCase()}',
          styles: const PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ));

      if (vehicleType != null) {
        bytes += generator.text('TIPO: ${vehicleType.toUpperCase()}',
            styles: const PosStyles(
              align: PosAlign.left,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            ));
      }

      // Date and time
      final dateTime = checkInTime ?? DateTimeService.now();
      final formattedDate = dateTime.formatDate();
      final formattedTime = dateTime.formatTime();
      
      bytes += generator.text('Fecha: $formattedDate',
          styles: const PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ));
      
      bytes += generator.text('Hora: $formattedTime',
          styles: const PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ));

      bytes += generator.emptyLines(1);

      // QR code
      bytes += generator.qrcode(plateNumber,
          size: QRSize.size6,
          cor: QRCorrection.M);

      bytes += generator.emptyLines(1);

      // Business resolution
      if (businessSetup.businessResolution.isNotEmpty) {
        bytes += generator.text('Resolución: ${businessSetup.businessResolution}',
            styles: const PosStyles(
              align: PosAlign.center,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            ));
        bytes += generator.emptyLines(1);
      }

      // Address
      if (businessSetup.address.isNotEmpty) {
        bytes += generator.text(businessSetup.address,
            styles: const PosStyles(
              align: PosAlign.center,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            ));
        bytes += generator.emptyLines(1);
      }

      // Footer
      bytes += _generateFooter(generator);

      // Cut paper
      bytes += generator.cut();

      // Send to printer
      await PrintBluetoothThermal.writeBytes(bytes);
      
      _logger.i('Check-in ticket printed successfully for $plateNumber');
      return true;
    });
  }

  /// Print a check-out receipt
  Future<bool> printCheckOutReceipt({
    required String plateNumber,
    required BusinessSetupModel businessSetup,
    required DateTime checkInTime,
    required DateTime checkOutTime,
    required double totalCost,
    required String vehicleType,
    double? discount,
    String? paymentMethod,
  }) async {
    return _printWithRetry(() async {
      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm80, profile);
      List<int> bytes = [];

      // Business header
      bytes += _generateBusinessHeader(generator, businessSetup);
      
      // Check-out header
      bytes += generator.text('SALIDA DE VEHICULO',
          styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ));
      
      bytes += generator.emptyLines(1);

      // Vehicle details
      bytes += generator.text('PLACA: ${plateNumber.toUpperCase()}',
          styles: const PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ));

      bytes += generator.text('TIPO: ${vehicleType.toUpperCase()}',
          styles: const PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ));

      // Time details 
      final formattedCheckInDate = checkInTime.formatDate();
      final formattedCheckInTime = checkInTime.formatTime();
      final formattedCheckOutDate = checkOutTime.formatDate();
      final formattedCheckOutTime = checkOutTime.formatTime();
      
      bytes += generator.text('Entrada: $formattedCheckInDate $formattedCheckInTime',
          styles: const PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ));
      
      bytes += generator.text('Salida: $formattedCheckOutDate $formattedCheckOutTime',
          styles: const PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ));

      // Duration
      final duration = checkOutTime.difference(checkInTime);
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      bytes += generator.text('Duración: ${hours}h ${minutes}m',
          styles: const PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ));

      bytes += generator.hr();

      // Cost breakdown
      bytes += generator.text('TOTAL A PAGAR:',
          styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ));
      
      bytes += generator.text('\$${totalCost.toStringAsFixed(2)}',
          styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          ));

      if (discount != null && discount > 0) {
        bytes += generator.text('Descuento: -\$${discount.toStringAsFixed(2)}',
            styles: const PosStyles(
              align: PosAlign.left,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            ));
      }

      if (paymentMethod != null) {
        bytes += generator.text('Método: ${paymentMethod.toUpperCase()}',
            styles: const PosStyles(
              align: PosAlign.left,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            ));
      }

      bytes += generator.emptyLines(1);

      // Footer
      bytes += _generateFooter(generator);

      // Cut paper
      bytes += generator.cut();

      // Send to printer
      await PrintBluetoothThermal.writeBytes(bytes);
      
      _logger.i('Check-out receipt printed successfully for $plateNumber');
      return true;
    });
  }

  /// Print a record ticket (for records list)
  Future<bool> printRecordTicket({
    required ActiveVehicleLogModel record,
    required BusinessSetupModel businessSetup,
  }) async {
    return _printWithRetry(() async {
      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm80, profile);
      List<int> bytes = [];

      // Business header
      bytes += _generateBusinessHeader(generator, businessSetup);
      
      // Record header
      bytes += generator.text('REGISTRO DE VEHICULO',
          styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ));
      
      bytes += generator.emptyLines(1);

      // Vehicle details
      bytes += generator.text('PLACA: ${record.vehicleId.plateNumber.toUpperCase()}',
          styles: const PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ));

      bytes += generator.text('TIPO: ${record.vehicleId.vehicleType.toUpperCase()}',
          styles: const PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ));

      // Entry time
      final entryTime = DateTimeService.fromUtc(record.entryTime);
      final formattedEntryDate = entryTime.formatDate();
      final formattedEntryTime = entryTime.formatTime();
      
      bytes += generator.text('Entrada: $formattedEntryDate $formattedEntryTime',
          styles: const PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ));

      // Exit time (if available)
      if (record.exitTime != null) {
        final exitTime = DateTimeService.fromUtc(record.exitTime!);
        final formattedExitDate = exitTime.formatDate();
        final formattedExitTime = exitTime.formatTime();
        
        bytes += generator.text('Salida: $formattedExitDate $formattedExitTime',
            styles: const PosStyles(
              align: PosAlign.left,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            ));
      }

      // Duration
      if (record.exitTime != null) {
        final duration = _formatDuration(record.duration);
        bytes += generator.text('Duración: $duration',
            styles: const PosStyles(
              align: PosAlign.left,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            ));
      } else {
        bytes += generator.text('Estado: EN PARQUEADERO',
            styles: const PosStyles(
              align: PosAlign.left,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            ));
      }

      // Cost (if available)
      if (record.cost > 0) {
        bytes += generator.text('Costo: \$${record.cost.toStringAsFixed(2)}',
            styles: const PosStyles(
              align: PosAlign.left,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            ));
      }

      bytes += generator.emptyLines(1);

      // QR code
      bytes += generator.qrcode(record.vehicleId.plateNumber,
          size: QRSize.size6,
          cor: QRCorrection.M);

      bytes += generator.emptyLines(1);

      // Business resolution
      if (businessSetup.businessResolution.isNotEmpty) {
        bytes += generator.text('Resolución: ${businessSetup.businessResolution}',
            styles: const PosStyles(
              align: PosAlign.center,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            ));
        bytes += generator.emptyLines(1);
      }

      // Address
      if (businessSetup.address.isNotEmpty) {
        bytes += generator.text(businessSetup.address,
            styles: const PosStyles(
              align: PosAlign.center,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            ));
        bytes += generator.emptyLines(1);
      }

      // Footer
      bytes += _generateFooter(generator);

      // Cut paper
      bytes += generator.cut();

      // Send to printer
      await PrintBluetoothThermal.writeBytes(bytes);
      
      _logger.i('Record ticket printed successfully for ${record.vehicleId.plateNumber}');
      return true;
    });
  }

  /// Check if printer is connected
  Future<bool> isPrinterConnected() async {
    try {
      return await PrintBluetoothThermal.connectionStatus;
    } catch (e) {
      _logger.e('Error checking printer connection: $e');
      return false;
    }
  }

  /// Print with retry mechanism
  Future<bool> _printWithRetry(Future<bool> Function() printFunction) async {
    for (int attempt = 1; attempt <= _maxRetries; attempt++) {
      try {
        // Check if printer is connected
        final bool isConnected = await isPrinterConnected();
        if (!isConnected) {
          _logger.w('Printer not connected on attempt $attempt');
          if (attempt < _maxRetries) {
            await Future.delayed(_retryDelay);
            continue;
          }
          throw Exception('Printer not connected after $_maxRetries attempts');
        }

        return await printFunction();
      } catch (e) {
        _logger.e('Print attempt $attempt failed: $e');
        if (attempt < _maxRetries) {
          await Future.delayed(_retryDelay);
        } else {
          rethrow;
        }
      }
    }
    return false;
  }

  /// Generate business header
  List<int> _generateBusinessHeader(Generator generator, BusinessSetupModel businessSetup) {
    List<int> bytes = [];

    // Business name
    bytes += generator.text(businessSetup.businessName,
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));
    
    // Business NIT
    if (businessSetup.businessNit.isNotEmpty) {
      bytes += generator.text('NIT: ${businessSetup.businessNit}',
          styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ));
    }
    
    bytes += generator.emptyLines(1);
    return bytes;
  }

  /// Generate footer
  List<int> _generateFooter(Generator generator) {
    List<int> bytes = [];

    bytes += generator.text('¡Gracias por usar nuestro parqueadero!',
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ));
    
    bytes += generator.text('Powered by quantum-devs.xyz',
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ));

    return bytes;
  }

  /// Format duration in hours and minutes
  String _formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    
    if (hours > 0) {
      return '${hours}h ${remainingMinutes}m';
    } else {
      return '${remainingMinutes}m';
    }
  }
} 