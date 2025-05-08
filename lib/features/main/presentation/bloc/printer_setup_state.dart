import 'package:equatable/equatable.dart';

abstract class PrinterSetupState extends Equatable {
  const PrinterSetupState();

  @override
  List<Object?> get props => [];
}

class PrinterSetupInitial extends PrinterSetupState {}

class PrinterSetupLoading extends PrinterSetupState {}

class PrinterSetupSuccess extends PrinterSetupState {
  final List<String> pairedDevices;
  final String? selectedPrinter;
  final bool isConnected;

  const PrinterSetupSuccess({
    required this.pairedDevices,
    this.selectedPrinter,
    this.isConnected = false,
  });

  @override
  List<Object?> get props => [pairedDevices, selectedPrinter, isConnected];
}

class PrinterSetupError extends PrinterSetupState {
  final String message;

  const PrinterSetupError(this.message);

  @override
  List<Object> get props => [message];
} 