import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/main/data/datasources/local_storage_service.dart';
import 'package:quantum_parking_flutter/features/main/data/models/vehicle_model.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_event.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_state.dart';
import 'package:quantum_parking_flutter/injection/injection.dart';

// Bloc
class MainBloc extends Bloc<MainEvent, MainState> {
  final LocalStorageService _localStorageService;
  String _plateNumber = '';
  String _vehicleType = '';
  String _checkOutPlateNumber = '';
  String _discount = '0';

  MainBloc() : _localStorageService = getIt<LocalStorageService>(), super(MainInitial()) {
    on<PlateNumberChanged>((event, emit) {
      _plateNumber = event.plateNumber;

    });
    on<VehicleTypeChanged>((event, emit) {
      _vehicleType = event.vehicleType;
    });
    on<CheckInRequested>(_checkInRequested);
    on<CheckOutPlateNumberChanged>((event, emit) {
      _checkOutPlateNumber = event.plateNumber;
    });
    on<DiscountChanged>((event, emit) {
      _discount = event.discount;
    });
    on<CheckOutRequested>(_checkOutRequested);
  }

  void _checkOutRequested(CheckOutRequested event, Emitter<MainState> emit) async {
    emit(MainLoading());
    try {
      if (_checkOutPlateNumber.isEmpty) {
        emit(const MainError('Plate number is required', isCheckout: true));
        return;
      }

      final vehicle = await _localStorageService.getVehicle(_checkOutPlateNumber);
      if (vehicle == null) {
        emit(const MainError('Vehicle not found', isCheckout: true));
        return;
      }

      if (vehicle.checkOut != null) {
        emit(const MainError('Vehicle is already checked out', isCheckout: true));
        return;
      }

      final checkOutTime = DateTime.now();
      final duration = checkOutTime.difference(vehicle.checkIn);
      final hours = duration.inHours + (duration.inMinutes % 60 > 0 ? 1 : 0);
      
      // TODO: Get rate from business setup
      const ratePerHour = 10.0;
      final totalCost = hours * ratePerHour;
      final discount = double.tryParse(_discount) ?? 0.0;
      final finalCost = totalCost - discount;

      final updatedVehicle = VehicleModel(
        plateNumber: vehicle.plateNumber,
        vehicleType: vehicle.vehicleType,
        checkIn: vehicle.checkIn,
        checkOut: checkOutTime,
        totalCost: totalCost,
        discount: discount,
      );

      final success = await _localStorageService.updateVehicle(updatedVehicle);
      if (!success) {
        emit(const MainError('Failed to update vehicle', isCheckout: true ));
        return;
      }

      emit(CheckOutSuccess(
        totalCost: totalCost,
        discount: discount,
        finalCost: finalCost,
      ));
    } catch (e) {
      emit(MainError(e.toString()));
    }
  }

  void _checkInRequested(CheckInRequested event, Emitter<MainState> emit) async {
    emit(MainLoading());
    try {
      if (_plateNumber.isEmpty || _vehicleType.isEmpty) {
        emit(const MainError('Plate number and vehicle type are required', isCheckin: true));
        return;
      }

      final vehicle = VehicleModel(
        plateNumber: _plateNumber,
        vehicleType: _vehicleType,
        checkIn: DateTime.now(),
      );

      final success = await _localStorageService.saveVehicle(vehicle);
      if (!success) {
        emit(const MainError('Vehicle is already checked in'));
        return;
      }

      emit(CheckInSuccess());
    } catch (e) {
      emit(MainError(e.toString()));
    }
  }
} 