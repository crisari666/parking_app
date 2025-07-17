// Events
import 'package:equatable/equatable.dart';

abstract class MainEvent extends Equatable {
  const MainEvent();

  @override
  List<Object?> get props => [];
}

class PlateNumberChanged extends MainEvent {
  final String plateNumber;

  const PlateNumberChanged(this.plateNumber);

  @override
  List<Object> get props => [plateNumber];
}

class VehicleTypeChanged extends MainEvent {
  final String vehicleType;

  const VehicleTypeChanged(this.vehicleType);

  @override
  List<Object> get props => [vehicleType];
}

class CheckInRequested extends MainEvent {}

class CheckOutPlateNumberChanged extends MainEvent {
  final String plateNumber;

  const CheckOutPlateNumberChanged(this.plateNumber);

  @override
  List<Object> get props => [plateNumber];
}

class DiscountChanged extends MainEvent {
  final String discount;

  const DiscountChanged(this.discount);

  @override
  List<Object> get props => [discount];
}

class StudentRateChanged extends MainEvent {
  final bool isStudentRate;

  const StudentRateChanged(this.isStudentRate);

  @override
  List<Object> get props => [isStudentRate];
}

class FindVehicleInParkingRequested extends MainEvent {
  final String plateNumber;

  const FindVehicleInParkingRequested(this.plateNumber);

  @override
  List<Object> get props => [plateNumber];
}

class VehicleFoundSuccessEvent extends MainEvent {
  final String parkingTime;
  final double paymentValue;

  const VehicleFoundSuccessEvent({
    required this.parkingTime,
    required this.paymentValue,
  });

  @override
  List<Object> get props => [parkingTime, paymentValue];
}

class CheckOutRequested extends MainEvent {
  final String plate;
  final String paymentMethod;
  final double? paymentValue;
  final bool shouldPrint;

  const CheckOutRequested({
    required this.plate,
    required this.paymentMethod,
    this.paymentValue,
    this.shouldPrint = false,
  });

  @override
  List<Object?> get props => [plate, paymentMethod, shouldPrint];
}

class PaymentMethodChanged extends MainEvent {
  final String method;

  const PaymentMethodChanged(this.method);

  @override
  List<Object> get props => [method];
}

class VerifySetupRequested extends MainEvent {}

class PrinterSetupRequested extends MainEvent {
  final String? printerName;
  final bool isConnected;

  const PrinterSetupRequested({
    this.printerName,
    this.isConnected = false,
  });

  @override
  List<Object?> get props => [printerName, isConnected];
}

class CheckOutPaymentValueChanged extends MainEvent {
  final double paymentValue;

  const CheckOutPaymentValueChanged(this.paymentValue);

  @override
  List<Object> get props => [paymentValue];
}

class ResetCheckOutForm extends MainEvent {}

class PrintQRCodeRequested extends MainEvent {
  final String plateNumber;
  final DateTime? vehicleLogDate;

  const PrintQRCodeRequested(this.plateNumber, {this.vehicleLogDate});

  @override
  List<Object?> get props => [plateNumber, vehicleLogDate];
}

class ClearMessage extends MainEvent {}

class ClearChecksForm extends MainEvent {}

class QRCodeScanned extends MainEvent {
  final String plateNumber;

  const QRCodeScanned(this.plateNumber);

  @override
  List<Object> get props => [plateNumber];
}

class CheckPrinterConnectionStatus extends MainEvent {}

class PerformPrinterHardwareTest extends MainEvent {}

class PrintCheckOutReceiptRequested extends MainEvent {
  final String plateNumber;
  final DateTime checkInTime;
  final DateTime checkOutTime;
  final double totalCost;
  final String vehicleType;
  final double? discount;
  final String? paymentMethod;

  const PrintCheckOutReceiptRequested({
    required this.plateNumber,
    required this.checkInTime,
    required this.checkOutTime,
    required this.totalCost,
    required this.vehicleType,
    this.discount,
    this.paymentMethod,
  });

  @override
  List<Object?> get props => [plateNumber, checkInTime, checkOutTime, totalCost, vehicleType, discount, paymentMethod];
}