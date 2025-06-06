import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/main/data/datasources/local_storage_service.dart';
import 'package:quantum_parking_flutter/features/main/data/models/vehicle_model.dart';
import 'package:quantum_parking_flutter/features/main/domain/repositories/vehicle_repository.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_event.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_state.dart';
import 'package:quantum_parking_flutter/features/setup/data/datasources/business_remote_datasource.dart';
import 'package:quantum_parking_flutter/features/setup/data/datasources/setup_local_datasource.dart';

// Bloc
class MainBloc extends Bloc<MainEvent, MainState> {
  final VehicleRepository _vehicleRepository;
  final LocalStorageService _localStorageService;
  final SetupLocalDatasource _setupLocalDatasource;
  final BusinessRemoteDatasource _businessRemoteDatasource;
  String? _printerName;
  bool _isPrinterConnected = false;
  double? _paymentValue;

  MainBloc({
    required LocalStorageService localStorageService,
    required SetupLocalDatasource setupLocalDatasource,
    required BusinessRemoteDatasource businessRemoteDatasource,
    required VehicleRepository vehicleRepository,
  }) : _localStorageService = localStorageService,
       _setupLocalDatasource = setupLocalDatasource,
       _businessRemoteDatasource = businessRemoteDatasource,
       _vehicleRepository = vehicleRepository,
       super(MainState.initial()) {
    on<PlateNumberChanged>(_handlePlateNumberChanged);
    on<VehicleTypeChanged>(_handleVehicleTypeChanged);
    on<CheckInRequested>(_checkInRequested);
    on<CheckOutPlateNumberChanged>(_handleCheckOutPlateNumberChanged);
    on<DiscountChanged>(_handleDiscountChanged);
    on<CheckOutRequested>(_checkOutRequested);
    on<VerifySetupRequested>(_verifySetup);
    on<PaymentMethodChanged>(_handlePaymentMethodChanged);
    on<FindVehicleInParkingRequested>(_findVehicleInParking);
    on<PrinterSetupRequested>(_handlePrinterSetup);
    on<CheckOutPaymentValueChanged>(_handleCheckOutPaymentValueChanged);
    on<ResetCheckOutForm>(_handleResetCheckOutForm);
  }

  void _handlePlateNumberChanged(PlateNumberChanged event, Emitter<MainState> emit) {
    emit(state.copyWith(plateNumber: event.plateNumber));
  }

  void _handleVehicleTypeChanged(VehicleTypeChanged event, Emitter<MainState> emit) {
    emit(state.copyWith(vehicleType: event.vehicleType));
  }

  void _handleCheckOutPlateNumberChanged(CheckOutPlateNumberChanged event, Emitter<MainState> emit) {
    emit(state.copyWith(checkOutPlateNumber: event.plateNumber));
  }

  void _handleDiscountChanged(DiscountChanged event, Emitter<MainState> emit) {
    emit(state.copyWith(discount: event.discount));
  }

  void _handlePaymentMethodChanged(PaymentMethodChanged event, Emitter<MainState> emit) {
    emit(state.copyWith(paymentMethod: event.method));
  }

  void _handlePrinterSetup(PrinterSetupRequested event, Emitter<MainState> emit) {
    _printerName = event.printerName;
    _isPrinterConnected = event.isConnected;
    emit(MainState.printerSetup(
      printerName: _printerName,
      isConnected: _isPrinterConnected,
    ));
  }

  void _handleCheckOutPaymentValueChanged(CheckOutPaymentValueChanged event, Emitter<MainState> emit) {
    _paymentValue = event.paymentValue;
    emit(state.copyWith(paymentValue: _paymentValue));
  }

  void _handleResetCheckOutForm(ResetCheckOutForm event, Emitter<MainState> emit) {
    emit(state.copyWith(
      checkOutPlateNumber: '',
      clearParkingTime: true,
      clearPaymentValue: true,
      clearVehicleLog: true,
      discount: '',
    ));
  }

  void _checkOutRequested(CheckOutRequested event, Emitter<MainState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      if (state.checkOutPlateNumber.isEmpty) {
        emit(MainState.error(message: 'Plate number is required', isCheckout: true));
        return;
      }

      final vehicle = await _localStorageService.getVehicle(state.checkOutPlateNumber);
      if (vehicle == null) {
        emit(MainState.error(message: 'Vehicle not found', isCheckout: true));
        return;
      }

      if (vehicle.checkOut != null) {
        emit(MainState.error(message: 'Vehicle is already checked out', isCheckout: true));
        return;
      }

      final setup = await _setupLocalDatasource.getSetup();
      if (setup == null) {
        emit(MainState.error(message: 'Business setup not found', isCheckout: true));
        return;
      }

      await _vehicleRepository.checkoutVehicle(state.checkOutPlateNumber, state.paymentValue?.toInt() ?? 0);
      emit(MainState.success('Vehicle checked out successfully'));
    } catch (e) {
      emit(MainState.error(message: e.toString(), isCheckout: true));
    }
  }

  void _checkInRequested(CheckInRequested event, Emitter<MainState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      if (state.plateNumber.isEmpty || state.vehicleType.isEmpty) {
        emit(MainState.error(message: 'Plate number and vehicle type are required', isCheckin: true));
        return;
      }

      final vehicle = VehicleModel(
        plateNumber: state.plateNumber,
        vehicleType: state.vehicleType,
        checkIn: DateTime.now(),
      );

      await _vehicleRepository.checkInVehicle(vehicle);
      emit(MainState.checkInSuccess());
    } catch (e) {
      emit(MainState.error(message: e.toString()));
    }
  }

  Future<void> _verifySetup(
    VerifySetupRequested event,
    Emitter<MainState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final setup = await _setupLocalDatasource.getSetup();
      if (setup == null) {
        final business = await _businessRemoteDatasource.getBusiness();
        if (business != null) {
          final setup = business;
          await _setupLocalDatasource.saveSetup(setup);
          emit(MainState.setupVerified());
        } else {
          emit(MainState.setupRequired());
        }
      } else {
        emit(MainState.setupVerified());
      }
    } catch (e) {
      emit(MainState.error(message: e.toString()));
    }
  }

  Future<void> _findVehicleInParking(FindVehicleInParkingRequested event, Emitter<MainState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final setup = await _setupLocalDatasource.getSetup();
      if (setup == null) {
        emit(MainState.error(message: 'Business setup not found', isCheckout: true));
        return;
      }

      final parkingInfo = await _vehicleRepository.getCurrentParkingDurationAndCost(event.plateNumber);
      if (parkingInfo == null) {
        emit(MainState.error(message: 'Vehicle not found', isCheckout: true));
        return;
      }

      final duration = DateTime.now().difference(parkingInfo.entryTime);
      final totalMinutes = duration.inMinutes;
      final hours = totalMinutes ~/ 60;
      final extraMinutes = totalMinutes % 60;
    
      // Grace period: if extraMinutes <= 10, do not charge for next hour
      final billableHours = extraMinutes > 10 ? hours + 1 : hours;
      
      // Get rate from business setup based on vehicle type
      final ratePerHour = parkingInfo.vehicleId.toLowerCase().contains('car') 
          ? setup.carHourCost 
          : setup.motorcycleHourCost;
      
      final paymentValue = (parkingInfo.duration / 60) * ratePerHour;
      final parkingTime = '${parkingInfo.duration}m';

      emit(state.copyWith(
        parkingTime: parkingTime,
        paymentValue: paymentValue,
        vehicleLog: parkingInfo,
        isLoading: false,
        paymentMethod: state.paymentMethod ?? 'cash',
      ));
    } catch (e) {
      emit(MainState.error(message: e.toString()));
    }
  }
} 