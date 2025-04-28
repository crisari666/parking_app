import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/main/domain/repositories/vehicle_repository.dart';
import 'package:quantum_parking_flutter/features/closure/presentation/bloc/closure_event.dart';
import 'package:quantum_parking_flutter/features/closure/presentation/bloc/closure_state.dart';

// Bloc
class ClosureBloc extends Bloc<ClosureEvent, ClosureState> {
  final VehicleRepository _vehicleRepository;

  ClosureBloc({required VehicleRepository vehicleRepository})
      : _vehicleRepository = vehicleRepository,
        super(ClosureInitial()) {
    on<GenerateDailyClosureRequested>(_onGenerateDailyClosure);
    on<LoadDailyClosuresRequested>(_onLoadDailyClosures);
  }

  Future<void> _onGenerateDailyClosure(GenerateDailyClosureRequested event, Emitter<ClosureState> emit) async {
    emit(ClosureLoading());
    try {
      final date = DateTime.now();
      final startDate = DateTime(date.year, date.month, date.day);
      final closure = await _vehicleRepository.getDailyClosure(startDate);
      final success = await _vehicleRepository.saveDailyClosure(closure);
      if (success) {
        emit(ClosureSuccess(closure));
      } else {
        emit(const ClosureError('Failed to save daily closure'));
      }
    } catch (e) {
      emit(ClosureError(e.toString()));
    }
  }

  Future<void> _onLoadDailyClosures(LoadDailyClosuresRequested event, Emitter<ClosureState> emit) async {
    emit(ClosureLoading());
    try {
      final date = DateTime.now();
      final startDate = DateTime(date.year, date.month, date.day);
      final endDate = startDate.add(const Duration(days: 1));
      final closures = await _vehicleRepository.getDailyClosures(
        startDate,
        endDate,
      );
      emit(ClosuresLoaded(closures));
    } catch (e) {
      emit(ClosureError(e.toString()));
    }
  }
} 