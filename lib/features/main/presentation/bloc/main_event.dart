// Events
import 'package:equatable/equatable.dart';

abstract class MainEvent extends Equatable {
  const MainEvent();

  @override
  List<Object> get props => [];
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

class CheckOutRequested extends MainEvent {}