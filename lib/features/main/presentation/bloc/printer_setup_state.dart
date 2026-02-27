import 'package:equatable/equatable.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

abstract class PrinterSetupState extends Equatable {
  const PrinterSetupState();

  @override
  List<Object?> get props => [];
}

class PrinterSetupInitial extends PrinterSetupState {}

class PrinterSetupLoading extends PrinterSetupState {}

class PrinterSetupSuccess extends PrinterSetupState {
  final List<BluetoothInfo> pairedDevices;
  final String? selectedPrinter;
  final bool isConnected;

  const PrinterSetupSuccess({
    required this.pairedDevices,
    this.selectedPrinter,
    this.isConnected = false,
  });

  @override
  List<Object?> get props => [
        pairedDevices.map((d) => d.macAdress).toList(),
        selectedPrinter,
        isConnected,
      ];
}

class PrinterSetupError extends PrinterSetupState {
  final String message;

  const PrinterSetupError(this.message);

  @override
  List<Object> get props => [message];
} 