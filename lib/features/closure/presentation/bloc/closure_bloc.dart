import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class ClosureEvent extends Equatable {
  const ClosureEvent();

  @override
  List<Object> get props => [];
}

class LoadClosureRequested extends ClosureEvent {}

// States
abstract class ClosureState extends Equatable {
  const ClosureState();

  @override
  List<Object> get props => [];
}

class ClosureInitial extends ClosureState {}

class ClosureLoading extends ClosureState {}

class ClosureSuccess extends ClosureState {
  final DateTime date;
  final int totalVehicles;
  final int totalCars;
  final int totalMotorcycles;
  final double totalSales;
  final double totalDiscounts;
  final double netSales;

  const ClosureSuccess({
    required this.date,
    required this.totalVehicles,
    required this.totalCars,
    required this.totalMotorcycles,
    required this.totalSales,
    required this.totalDiscounts,
    required this.netSales,
  });

  @override
  List<Object> get props => [
        date,
        totalVehicles,
        totalCars,
        totalMotorcycles,
        totalSales,
        totalDiscounts,
        netSales,
      ];
}

class ClosureError extends ClosureState {
  final String message;

  const ClosureError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class ClosureBloc extends Bloc<ClosureEvent, ClosureState> {
  ClosureBloc() : super(ClosureInitial()) {
    on<LoadClosureRequested>((event, emit) async {
      emit(ClosureLoading());
      try {
        // TODO: Implement closure loading logic
        emit(ClosureSuccess(
          date: DateTime.now(),
          totalVehicles: 0,
          totalCars: 0,
          totalMotorcycles: 0,
          totalSales: 0.0,
          totalDiscounts: 0.0,
          netSales: 0.0,
        ));
      } catch (e) {
        emit(ClosureError(e.toString()));
      }
    });
  }
} 