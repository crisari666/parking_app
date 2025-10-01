import 'package:equatable/equatable.dart';

abstract class PrinterSetupEvent extends Equatable {
  const PrinterSetupEvent();

  @override
  List<Object?> get props => [];
}

class PrinterSetupStarted extends PrinterSetupEvent {}

class PrinterSetupCheckPermissions extends PrinterSetupEvent {}

class PrinterSetupGetPairedDevices extends PrinterSetupEvent {}

class PrinterSetupConnectToPrinter extends PrinterSetupEvent {
  final String macAddress;

  const PrinterSetupConnectToPrinter(this.macAddress);

  @override
  List<Object> get props => [macAddress];
}

class PrinterSetupDisconnect extends PrinterSetupEvent {} 