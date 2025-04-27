// States
import 'package:equatable/equatable.dart';

abstract class MainState extends Equatable {
  const MainState();

  @override
  List<Object> get props => [];
}

class MainInitial extends MainState {}

class MainLoading extends MainState {}

class CheckInSuccess extends MainState {}

class CheckOutSuccess extends MainState {
  final double totalCost;
  final double discount;
  final double finalCost;

  const CheckOutSuccess({
    required this.totalCost,
    required this.discount,
    required this.finalCost,
  });

  @override
  List<Object> get props => [totalCost, discount, finalCost];
}

class MainError extends MainState {
  final bool isCheckin;
  final bool isCheckout;
  final String message;

  const MainError(this.message, {this.isCheckin = false, this.isCheckout = false});

  @override
  List<Object> get props => [message, isCheckin, isCheckout];
}

class SetupRequired extends MainState {}

class SetupVerified extends MainState {}

class VehicleFoundSuccess extends MainState {
  final String parkingTime;
  final double paymentValue;
  final String paymentMethod;

  const VehicleFoundSuccess({
    required this.parkingTime,
    required this.paymentValue,
    this.paymentMethod = 'cash',
  });

  @override
  List<Object> get props => [parkingTime, paymentValue, paymentMethod];
}

// Grace time 10 min
// Metodo de pago
// Mostrar