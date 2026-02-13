import 'dart:async';
import 'package:hive/hive.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:logger/logger.dart';
import 'package:quantum_parking_flutter/core/contants/hive_constants.dart';
import 'package:quantum_parking_flutter/core/utils/date_time_service.dart';
import 'package:quantum_parking_flutter/features/config/data/models/stored_printer_model.dart';

class PrinterRepository {
  static final PrinterRepository _instance = PrinterRepository._internal();
  factory PrinterRepository() => _instance;
  PrinterRepository._internal();

  final Logger _logger = Logger();
  final StreamController<PrinterConnectionState> _connectionStateController =
      StreamController<PrinterConnectionState>.broadcast();

  String? _currentPrinterName;
  bool _isConnected = false;

  Future<Box<StoredPrinterModel>> _getPrinterBox() async {
    if (!Hive.isBoxOpen(HiveConstants.printerBox)) {
      return Hive.openBox<StoredPrinterModel>(HiveConstants.printerBox);
    }
    return Hive.box<StoredPrinterModel>(HiveConstants.printerBox);
  }

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

  /// Returns the stored printer from local storage, or null if none.
  Future<StoredPrinterModel?> getStoredPrinter() async {
    try {
      final box = await _getPrinterBox();
      return box.get(HiveConstants.storedPrinterKey);
    } catch (e) {
      _logger.e('Error getting stored printer: $e');
      return null;
    }
  }

  /// Saves the selected printer to local storage for reconnection on app launch.
  Future<void> saveStoredPrinter({
    required String macAddress,
    required String name,
  }) async {
    try {
      final box = await _getPrinterBox();
      final now = DateTimeService.now();
      final model = StoredPrinterModel(
        macAddress: macAddress,
        name: name,
        createdAt: now,
        updatedAt: now,
      );
      await box.put(HiveConstants.storedPrinterKey, model);
      _logger.d('Stored printer saved: $name ($macAddress)');
    } catch (e) {
      _logger.e('Error saving stored printer: $e');
    }
  }

  /// Clears the stored printer from local storage.
  Future<void> clearStoredPrinter() async {
    try {
      final box = await _getPrinterBox();
      await box.delete(HiveConstants.storedPrinterKey);
      _logger.d('Stored printer cleared');
    } catch (e) {
      _logger.e('Error clearing stored printer: $e');
    }
  }

  /// Ensures the stored printer is connected: if a printer is stored and we are
  /// not connected, tries to connect to it. The device must be paired first.
  /// Returns true if connected (or already was), false otherwise.
  Future<bool> ensureStoredPrinterConnected() async {
    try {
      final stored = await getStoredPrinter();
      if (stored == null) {
        return await checkCurrentConnectionStatus(override: true);
      }

      bool isConnected = await checkCurrentConnectionStatus();
      if (isConnected) {
        return true;
      }

      // Try to connect to stored printer (must be paired with device).
      final connected = await connectToPrinter(stored.macAddress);
      if (connected) {
        _logger.d('Reconnected to stored printer: ${stored.name}');
      } else {
        _logger.w(
          'Could not connect to stored printer ${stored.name} '
          '(${stored.macAddress}). Ensure device is paired and in range.',
        );
      }
      return connected;
    } catch (e) {
      _logger.e('Error ensuring stored printer connected: $e');
      return await checkCurrentConnectionStatus(override: true);
    }
  }

  // Check current connection status from the printer library
  Future<bool> checkCurrentConnectionStatus({final bool override = false}) async {
    try {
      final bool isConnected = await PrintBluetoothThermal.connectionStatus;
      
      // Update internal state if it changed
      if (isConnected != _isConnected || override) {
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

  // Connect to a specific printer by MAC address
  Future<bool> connectToPrinter(String macAddress) async {
    try {
      final bool result = await PrintBluetoothThermal.connect(
        macPrinterAddress: macAddress,
      );

      if (result) {
        await updatePrinterConnection(
          printerName: macAddress,
          isConnected: true,
        );
        _logger.d('Successfully connected to printer: $macAddress');
      } else {
        await updatePrinterConnection(
          printerName: null,
          isConnected: false,
        );
        _logger.e('Failed to connect to printer: $macAddress');
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