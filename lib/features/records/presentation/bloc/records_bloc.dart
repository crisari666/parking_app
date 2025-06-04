import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/records_event.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/records_state.dart';
import 'package:quantum_parking_flutter/features/main/domain/repositories/vehicle_repository.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/models/vehicle_record.dart';

// Bloc
class RecordsBloc extends Bloc<RecordsEvent, RecordsState> {
  final VehicleRepository _vehicleRepository;

  RecordsBloc({
    required VehicleRepository vehicleRepository,
  }) : _vehicleRepository = vehicleRepository,
       super(RecordsState.initial()) {
    on<SearchPlateNumberChanged>(_searchPlateNumberChanged);
    on<LoadRecordsRequested>(_loadRecords);
    on<GetVehicleLogsRequested>(_getVehicleLogs);
  }

  Future<void> _searchPlateNumberChanged(SearchPlateNumberChanged event, Emitter<RecordsState> emit) async {
    if (event.plateNumber.isEmpty) {
      emit(RecordsState.success([]));
      return;
    }

    emit(RecordsState.loading());
    try {
      final vehicle = await _vehicleRepository.getVehicle(event.plateNumber);
      if (vehicle != null) {
        final record = VehicleRecord(
          plateNumber: vehicle.plateNumber,
          vehicleType: vehicle.vehicleType,
          checkIn: vehicle.checkIn,
          checkOut: vehicle.checkOut,
          totalCost: vehicle.totalCost,
          paymentMethod: vehicle.paymentMethod,
        );
        emit(RecordsState.success([record]));
      } else {
        emit(RecordsState.success([]));
      }
    } catch (e) {
      emit(RecordsState.error('Error searching for vehicle: ${e.toString()}'));
    }
  }

  Future<void> _loadRecords(LoadRecordsRequested event, Emitter<RecordsState> emit) async {
    emit(RecordsState.loading());
    try {
      final vehicles = await _vehicleRepository.getAllVehicles();
      final records = vehicles.map((vehicle) => VehicleRecord(
        plateNumber: vehicle.plateNumber,
        vehicleType: vehicle.vehicleType,
        checkIn: vehicle.checkIn,
        checkOut: vehicle.checkOut,
        totalCost: vehicle.totalCost,
        paymentMethod: vehicle.paymentMethod,
      )).toList();
      emit(RecordsState.success(records));
    } catch (e) {
      emit(RecordsState.error(e.toString()));
    }
  }

  Future<void> _getVehicleLogs(GetVehicleLogsRequested event, Emitter<RecordsState> emit) async {
    emit(state.copyWith(status: RecordsStatus.loading));
    
    try {
      final vehicleLogs = await _vehicleRepository.getVehicleParkingLogs(event.plateNumber);
      
      final records = vehicleLogs.map((log) => VehicleRecord(
        plateNumber: log.plateNumber,
        vehicleType: log.vehicleType ?? "",
        checkIn: log.checkIn,
        checkOut: log.checkOut,
        totalCost: log.totalCost,
        paymentMethod: log.paymentMethod,
      )).toList();
      
      emit(state.copyWith(
        status: RecordsStatus.success,
        vehicleLogs: records,
      ));
    } catch (e) {
      emit(RecordsState.error(e.toString()));
    }
  }
}   