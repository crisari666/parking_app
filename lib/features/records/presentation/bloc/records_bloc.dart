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
    on<GetVehicleLogsRequested>(_getVehicleLogs);
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

  Future<void> _getVehicleLogs(GetVehicleLogsRequested event, Emitter<RecordsState> emit) async {
    if (state is! RecordsSuccess) return;
    
    final currentState = state as RecordsSuccess;
    emit(RecordsLoading());
    
    try {
      final vehicleLogs = await _vehicleRepository.getVehicleParkingLogs    (event.plateNumber);
      
      final records = vehicleLogs.map((log) => VehicleRecord(
            plateNumber: log.plateNumber,
            vehicleType: log.vehicleType ?? "",
            checkIn: log.checkIn,
            checkOut: log.checkOut,
            totalCost: log.totalCost,
          )).toList();
      
      emit(RecordsSuccess(currentState.records, vehicleLogs: records));
    } catch (e) {
      emit(RecordsError(e.toString()));
    }
  }
}   