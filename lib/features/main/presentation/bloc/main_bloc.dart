import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
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

// States
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
  final String message;

  const MainError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainInitial()) {
    on<PlateNumberChanged>((event, emit) {
      // Handle plate number change
    });
    on<VehicleTypeChanged>((event, emit) {
      // Handle vehicle type change
    });
    on<CheckInRequested>((event, emit) async {
      emit(MainLoading());
      try {
        // TODO: Implement check-in logic
        emit(CheckInSuccess());
      } catch (e) {
        emit(MainError(e.toString()));
      }
    });
    on<CheckOutPlateNumberChanged>((event, emit) {
      // Handle check-out plate number change
    });
    on<DiscountChanged>((event, emit) {
      // Handle discount change
    });
    on<CheckOutRequested>((event, emit) async {
      emit(MainLoading());
      try {
        // TODO: Implement check-out logic
        emit(const CheckOutSuccess(
          totalCost: 0.0,
          discount: 0.0,
          finalCost: 0.0,
        ));
      } catch (e) {
        emit(MainError(e.toString()));
      }
    });
  }
} 