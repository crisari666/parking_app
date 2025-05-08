import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/main/data/datasources/local_storage_service.dart';
import 'package:quantum_parking_flutter/features/main/data/models/vehicle_model.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_event.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_state.dart';
import 'package:quantum_parking_flutter/features/setup/data/datasources/setup_local_datasource.dart';

// Bloc
class MainBloc extends Bloc<MainEvent, MainState> {
  final LocalStorageService _localStorageService;
  final SetupLocalDatasource _setupLocalDatasource;
  String _plateNumber = '';
  String _vehicleType = '';
  String _checkOutPlateNumber = '';
  String _discount = '0';
  String _paymentMethod = 'cash';
  String? _printerName;
  bool _isPrinterConnected = false;

  MainBloc({
    required LocalStorageService localStorageService,
    required SetupLocalDatasource setupLocalDatasource,
  }) : _localStorageService = localStorageService,
       _setupLocalDatasource = setupLocalDatasource,
       super(MainInitial()) {
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
    on<VerifySetupRequested>(_verifySetup);
    on<PaymentMethodChanged>(_handlePaymentMethodChanged);
    on<FindVehicleInParkingRequested>(_findVehicleInParking);
    on<PrinterSetupRequested>(_handlePrinterSetup);
  }

  void _handlePrinterSetup(PrinterSetupRequested event, Emitter<MainState> emit) {
    _printerName = event.printerName;
    _isPrinterConnected = event.isConnected;
    emit(PrinterSetupSuccess(
      printerName: _printerName,
      isConnected: _isPrinterConnected,
    ));
  }

  void _handlePaymentMethodChanged(PaymentMethodChanged event, Emitter<MainState> emit) {
    _paymentMethod = event.method;
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

      final setup = await _setupLocalDatasource.getSetup();
      if (setup == null) {
        emit(const MainError('Business setup not found', isCheckout: true));
        return;
      }

      final checkOutTime = DateTime.now();
      final duration = checkOutTime.difference(vehicle.checkIn);
      final totalMinutes = duration.inMinutes;
      final hours = totalMinutes ~/ 60;
      final extraMinutes = totalMinutes % 60;
      
      // Grace period: if extraMinutes <= 10, do not charge for next hour
      final billableHours = extraMinutes > 10 ? hours + 1 : hours;
      
      // Get rate from business setup based on vehicle type
      final ratePerHour = vehicle.vehicleType.toLowerCase() == 'car' 
          ? setup.carHourCost 
          : setup.motorcycleHourCost;
      
      final totalCost = billableHours * ratePerHour;
      final discount = double.tryParse(_discount) ?? 0.0;
      final finalCost = totalCost - discount;

      final updatedVehicle = VehicleModel(
        plateNumber: vehicle.plateNumber,
        vehicleType: vehicle.vehicleType,
        checkIn: vehicle.checkIn,
        checkOut: checkOutTime,
        totalCost: totalCost,
        discount: discount,
        paymentMethod: _paymentMethod,
      );

      final success = await _localStorageService.updateVehicle(updatedVehicle);
      if (success) {
        emit(MainSuccess('Vehicle checked out successfully'));
      } else {
        emit(const MainError('Failed to check out vehicle', isCheckout: true));
      }
    } catch (e) {
      emit(MainError(e.toString(), isCheckout: true));
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

  Future<void> _verifySetup(
    VerifySetupRequested event,
    Emitter<MainState> emit,
  ) async {
    emit(MainLoading());
    try {
      final setup = await _setupLocalDatasource.getSetup();
      if (setup == null) {
        emit(SetupRequired());
      } else {
        emit(SetupVerified());
      }
    } catch (e) {
      emit(MainError(e.toString()));
    }
  }

  Future<void> _findVehicleInParking(FindVehicleInParkingRequested event, Emitter<MainState> emit) async {
    emit(MainLoading());
    try {
      final vehicle = await _localStorageService.getVehicle(event.plateNumber);
      if (vehicle == null) {
        emit(const MainError('Vehicle not found', isCheckout: true));
        return;
      }

      if (vehicle.checkOut != null) {
        emit(const MainError('Vehicle is already checked out', isCheckout: true));
        return;
      }

      final setup = await _setupLocalDatasource.getSetup();
      if (setup == null) {
        emit(const MainError('Business setup not found', isCheckout: true));
        return;
      }

      final currentTime = DateTime.now();
      final duration = currentTime.difference(vehicle.checkIn);
      final totalMinutes = duration.inMinutes;
      final hours = totalMinutes ~/ 60;
      final extraMinutes = totalMinutes % 60;
      
      // Grace period: if extraMinutes <= 10, do not charge for next hour
      final billableHours = extraMinutes > 10 ? hours + 1 : hours;
      
      // Get rate from business setup based on vehicle type
      final ratePerHour = vehicle.vehicleType.toLowerCase() == 'car' 
          ? setup.carHourCost 
          : setup.motorcycleHourCost;
      
      final paymentValue = billableHours * ratePerHour;

      final parkingTime = '${hours}h ${extraMinutes}m';

      emit(VehicleFoundSuccess(
        parkingTime: parkingTime,
        paymentValue: paymentValue,
        paymentMethod: _paymentMethod,
      ));
    } catch (e) {
      emit(MainError(e.toString()));
    }
  }
} 