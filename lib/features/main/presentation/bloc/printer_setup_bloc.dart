import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:logger/logger.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/printer_setup_event.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/printer_setup_state.dart';

class PrinterSetupBloc extends Bloc<PrinterSetupEvent, PrinterSetupState> {
  final _logger = Logger();

  PrinterSetupBloc() : super(PrinterSetupInitial()) {
    on<PrinterSetupStarted>(_onStarted);
    on<PrinterSetupCheckPermissions>(_onCheckPermissions);
    on<PrinterSetupGetPairedDevices>(_onGetPairedDevices);
    on<PrinterSetupConnectToPrinter>(_onConnectToPrinter);
    on<PrinterSetupDisconnect>(_onDisconnect);
  }

  Future<void> _onStarted(
    PrinterSetupStarted event,
    Emitter<PrinterSetupState> emit,
  ) async {
    emit(PrinterSetupLoading());
    add(PrinterSetupCheckPermissions());
  }

  Future<void> _onCheckPermissions(
    PrinterSetupCheckPermissions event,
    Emitter<PrinterSetupState> emit,
  ) async {
    try {
      bool bluetoothGranted = await Permission.bluetooth.isGranted;
      bool bluetoothConnectGranted = await Permission.bluetoothConnect.isGranted;
      bool bluetoothScanGranted = await Permission.bluetoothScan.isGranted;
      bool locationGranted = await Permission.location.isGranted;

      if (!bluetoothGranted || !bluetoothConnectGranted || !bluetoothScanGranted || !locationGranted) {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.bluetooth,
          Permission.bluetoothConnect,
          Permission.bluetoothScan,
          Permission.location,
        ].request();

        bool allGranted = true;
        statuses.forEach((permission, status) {
          if (!status.isGranted) {
            allGranted = false;
            _logger.e('Permission $permission not granted');
          }
        });

        if (!allGranted) {
          emit(const PrinterSetupError('Please grant all required permissions in settings'));
          return;
        }
      }

      add(PrinterSetupGetPairedDevices());
    } catch (e) {
      _logger.e('Error checking permissions: $e');
      emit(PrinterSetupError(e.toString()));
    }
  }

  Future<void> _onGetPairedDevices(
    PrinterSetupGetPairedDevices event,
    Emitter<PrinterSetupState> emit,
  ) async {
    try {
      final List<BluetoothInfo> pairedDevices = await PrintBluetoothThermal.pairedBluetooths;
      final bool isConnected = await PrintBluetoothThermal.connectionStatus;
      
      final List<String> printerNames = List<String>.from(pairedDevices.map((device) => '${device.name} - ${device.macAdress}')).toList();
      emit(PrinterSetupSuccess(
        pairedDevices: printerNames,
        isConnected: isConnected,
      ));
    } catch (e) {
      _logger.e('Error getting paired devices: $e');
      emit(PrinterSetupError(e.toString()));
    }
  }

  Future<void> _onConnectToPrinter(
    PrinterSetupConnectToPrinter event,
    Emitter<PrinterSetupState> emit,
  ) async {
    try {
      final String macAddress = event.macAddress.split(' - ')[1];
      final bool isConnected = await PrintBluetoothThermal.connectionStatus;
      if (isConnected) {
        emit(PrinterSetupSuccess(
          pairedDevices: const [],
          isConnected: isConnected,
        ));
      } else {
        final bool result = await PrintBluetoothThermal.connect(
          macPrinterAddress: macAddress,
        );

        if (result == true) {
          final List pairedDevices = await PrintBluetoothThermal.pairedBluetooths;
          emit(PrinterSetupSuccess(
            pairedDevices: pairedDevices.cast<String>(),
            selectedPrinter: event.macAddress,
            isConnected: true,
          ));
        } else {
          emit(const PrinterSetupError('Failed to connect to printer'));
        }
      }
    } catch (e) {
      _logger.e('Error connecting to printer: $e');
      emit(PrinterSetupError(e.toString()));
    }
  }

  Future<void> _onDisconnect(
    PrinterSetupDisconnect event,
    Emitter<PrinterSetupState> emit,
  ) async {
    try {
      await PrintBluetoothThermal.disconnect;
      final List pairedDevices = await PrintBluetoothThermal.pairedBluetooths;
      
      emit(PrinterSetupSuccess(
        pairedDevices: pairedDevices.cast<String>(),
        isConnected: false,
      ));
    } catch (e) {
      _logger.e('Error disconnecting from printer: $e');
      emit(PrinterSetupError(e.toString()));
    }
  }
} 