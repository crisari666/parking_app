import 'dart:async';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:logger/logger.dart';

class PrinterRepository {
  static final PrinterRepository _instance = PrinterRepository._internal();
  factory PrinterRepository() => _instance;
  PrinterRepository._internal();

  final Logger _logger = Logger();
  final StreamController<PrinterConnectionState> _connectionStateController = 
      StreamController<PrinterConnectionState>.broadcast();

  String? _currentPrinterName;
  bool _isConnected = false;

  // Stream to listen to printer connection state changes
  Stream<PrinterConnectionState> get connectionStateStream => _connectionStateController.stream;

  // Current state getters
  String? get currentPrinterName => _currentPrinterName;
  bool get isConnected => _isConnected;

  // Update printer connection state
  Future<void> updatePrinterConnection({
    required String? printerName,
    required bool isConnected,
  }) async {
    _currentPrinterName = printerName;
    _isConnected = isConnected;

    final state = PrinterConnectionState(
      printerName: printerName,
      isConnected: isConnected,
    );

    _connectionStateController.add(state);
    _logger.d('Printer connection state updated: $state');
  }

  // Check current connection status from the printer library
  Future<bool> checkCurrentConnectionStatus() async {
    try {
      final bool isConnected = await PrintBluetoothThermal.connectionStatus;
      
      // Update internal state if it changed
      if (isConnected != _isConnected) {
        await updatePrinterConnection(
          printerName: _currentPrinterName,
          isConnected: isConnected,
        );
      }
      
      return isConnected; 
    } catch (e) {
      _logger.e('Error checking printer connection status: $e');
      return false;
    }
  }

  // Connect to a specific printer
  Future<bool>  connectToPrinter(String printerInfo) async {
    try {
      final String macAddress = printerInfo.split(' - ')[1];
      final bool result = await PrintBluetoothThermal.connect(
        macPrinterAddress: macAddress,
      );

      if (result) {
        await updatePrinterConnection(
          printerName: printerInfo,
          isConnected: true,
        );
        _logger.d('Successfully connected to printer: $printerInfo');
      } else {
        await updatePrinterConnection(
          printerName: null,
          isConnected: false,
        );
        _logger.e('Failed to connect to printer: $printerInfo');
      }

      return result;
    } catch (e) {
      _logger.e('Error connecting to printer: $e');
      await updatePrinterConnection(
        printerName: null,
        isConnected: false,
      );
      return false;
    }
  }

  // Disconnect from printer
  Future<void> disconnectPrinter() async {
    try {
      await PrintBluetoothThermal.disconnect;
      await updatePrinterConnection(
        printerName: null,
        isConnected: false,
      );
      _logger.d('Printer disconnected successfully');
    } catch (e) {
      _logger.e('Error disconnecting printer: $e');
      await updatePrinterConnection(
        printerName: null,
        isConnected: false,
      );
    }
  }

  // Dispose resources
  void dispose() {
    _connectionStateController.close();
  }
}

// Data class for printer connection state
class PrinterConnectionState {
  final String? printerName;
  final bool isConnected;

  const PrinterConnectionState({
    this.printerName,
    required this.isConnected,
  });

  @override
  String toString() {
    return 'PrinterConnectionState(printerName: $printerName, isConnected: $isConnected)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PrinterConnectionState &&
        other.printerName == printerName &&
        other.isConnected == isConnected;
  }

  @override
  int get hashCode => printerName.hashCode ^ isConnected.hashCode;
} 