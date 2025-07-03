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

  const CheckOutRequested({
    required this.plate,
    required this.paymentMethod,
    this.paymentValue,
  });

  @override
  List<Object> get props => [plate, paymentMethod];
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

  const PrintQRCodeRequested(this.plateNumber);

  @override
  List<Object> get props => [plateNumber];
}