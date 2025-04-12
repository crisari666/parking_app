import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_event.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_state.dart';

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