import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/main/domain/repositories/vehicle_repository.dart';
import 'package:quantum_parking_flutter/features/closure/presentation/bloc/closure_event.dart';
import 'package:quantum_parking_flutter/features/closure/presentation/bloc/closure_state.dart';
import 'package:quantum_parking_flutter/features/records/data/models/daily_closure_model.dart';
import 'package:quantum_parking_flutter/features/records/data/models/vehicle_log_model.dart';

// Bloc
class ClosureBloc extends Bloc<ClosureEvent, ClosureState> {
  final VehicleRepository _vehicleRepository;

  ClosureBloc({required VehicleRepository vehicleRepository})
      : _vehicleRepository = vehicleRepository,
        super(ClosureState.initial()) {
    on<GenerateDailyClosureRequested>(_onGenerateDailyClosure);
    on<LoadDailyClosuresRequested>(_onLoadDailyClosures);
    on<GetClosureDataByDate>(_onGetClosureDataByDate);
  }

  Future<void> _onGenerateDailyClosure(GenerateDailyClosureRequested event, Emitter<ClosureState> emit) async {
    emit(state.copyWith(status: ClosureStatus.loading));
    try {
      final date = DateTime.now();
      final startDate = DateTime(date.year, date.month, date.day);
      final closure = await _vehicleRepository.getDailyClosure(startDate);
      final success = await _vehicleRepository.saveDailyClosure(closure);
      if (success) {
        emit(state.copyWith(
          status: ClosureStatus.success,
          closure: closure,
        ));
      } else {
        emit(state.copyWith(
          status: ClosureStatus.error,
          errorMessage: 'Failed to save daily closure',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: ClosureStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadDailyClosures(LoadDailyClosuresRequested event, Emitter<ClosureState> emit) async {
    emit(state.copyWith(status: ClosureStatus.loading));
    try {
      final date = DateTime.now();
      final startDate = DateTime(date.year, date.month, date.day);
      final endDate = startDate.add(const Duration(days: 1));
      final closures = await _vehicleRepository.getDailyClosures(
        startDate,
        endDate,
      );
      emit(state.copyWith(
        status: ClosureStatus.success,
        closures: closures,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ClosureStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onGetClosureDataByDate(GetClosureDataByDate event, Emitter<ClosureState> emit) async {
    emit(state.copyWith(status: ClosureStatus.loading));
    try {
      final date = event.date;
      final formattedDate = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final vehicleLogs = await _vehicleRepository.getVehicleLogsByDate(formattedDate);
      
      // Calculate totals and organize data
      double totalIncome = 0;
      Map<String, int> vehiclesByType = {};
      Map<String, double> incomeByPaymentMethod = {};
      List<VehicleLogModel> processedLogs = [];

      for (var log in vehicleLogs) {
        if (log.cost > 0) {
          totalIncome += log.cost.toDouble();
        }

        // Count vehicles by type
        final vehicleType = log.vehicleId.vehicleType;
        vehiclesByType[vehicleType] = (vehiclesByType[vehicleType] ?? 0) + 1;

        // Convert ActiveVehicleLogModel to VehicleLogModel
        processedLogs.add(VehicleLogModel(
          plateNumber: log.vehicleId.plateNumber,
          vehicleType: vehicleType,
          checkIn: log.entryTime,
          checkOut: log.exitTime,
          totalCost: log.cost.toDouble(),
          discount: null, // No discount in response model
          paymentMethod: null, // No payment method in ActiveVehicleLogModel
        ));
      }
      
      final closure = DailyClosureModel(
        date: date,
        totalIncome: totalIncome,
        totalVehicles: vehicleLogs.length,
        vehiclesByType: vehiclesByType,
        incomeByPaymentMethod: incomeByPaymentMethod,
        vehicleLogs: processedLogs,
      );
      
      emit(state.copyWith(
        status: ClosureStatus.success,
        closure: closure,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ClosureStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
} 