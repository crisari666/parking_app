import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/records_event.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/records_state.dart';
import 'package:quantum_parking_flutter/features/main/domain/repositories/vehicle_repository.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/models/vehicle_record.dart';

// Bloc
class RecordsBloc extends Bloc<RecordsEvent, RecordsState> {
  final VehicleRepository _vehicleRepository;

  RecordsBloc(this._vehicleRepository) : super(RecordsInitial()) {
    on<SearchPlateNumberChanged>(_searchPlateNumberChanged);
    on<LoadRecordsRequested>(_loadRecords);
  }

  Future<void> _searchPlateNumberChanged(SearchPlateNumberChanged event, Emitter<RecordsState> emit) async {
    if (event.plateNumber.isEmpty) {
      emit(const RecordsSuccess([]));
      return;
    }

    emit(RecordsLoading());
    try {
      final vehicle = await _vehicleRepository.getVehicle(event.plateNumber);
      if (vehicle != null) {
        final record = VehicleRecord(
          plateNumber: vehicle.plateNumber,
          vehicleType: vehicle.vehicleType,
          checkIn: vehicle.checkIn,
          checkOut: vehicle.checkOut,
          totalCost: vehicle.totalCost,
        );
        emit(RecordsSuccess([record]));
      } else {
        emit(const RecordsSuccess([]));
      }
    } catch (e) {
      emit(RecordsError('Error searching for vehicle: ${e.toString()}'));
    }
  }

  Future<void> _loadRecords(LoadRecordsRequested event, Emitter<RecordsState> emit) async {
    emit(RecordsLoading());
    try {
      final vehicles = await _vehicleRepository.getAllVehicles();
      final records = vehicles.map((vehicle) => VehicleRecord(
        plateNumber: vehicle.plateNumber,
        vehicleType: vehicle.vehicleType,
        checkIn: vehicle.checkIn,
        checkOut: vehicle.checkOut,
        totalCost: vehicle.totalCost,
      )).toList();
      emit(RecordsSuccess(records));
    } catch (e) {
      emit(RecordsError(e.toString()));
    }
  }
} 