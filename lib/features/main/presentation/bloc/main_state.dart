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