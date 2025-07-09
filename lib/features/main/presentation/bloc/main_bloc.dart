import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/main/data/datasources/local_storage_service.dart';
import 'package:quantum_parking_flutter/features/main/data/models/vehicle_log_response_model.dart';
import 'package:quantum_parking_flutter/features/main/data/models/vehicle_model.dart';
import 'package:quantum_parking_flutter/features/main/domain/repositories/vehicle_repository.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_event.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_state.dart';
import 'package:quantum_parking_flutter/features/setup/data/datasources/business_remote_datasource.dart';
import 'package:quantum_parking_flutter/features/setup/data/datasources/setup_local_datasource.dart';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';

// Bloc
class MainBloc extends Bloc<MainEvent, MainState> {
  final VehicleRepository _vehicleRepository;
  final LocalStorageService _localStorageService;
  final SetupLocalDatasource _setupLocalDatasource;
  final BusinessRemoteDatasource _businessRemoteDatasource;
  final Logger _logger = Logger();
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
    on<PrintQRCodeRequested>(_handlePrintQRCode);
    on<ClearMessage>(_handleClearMessage);
    on<QRCodeScanned>(_handleQRCodeScanned);
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
    emit(state.copyWith(printerName: _printerName, isPrinterConnected: _isPrinterConnected));
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

  void _handleClearMessage(ClearMessage event, Emitter<MainState> emit) {
    emit(state.copyWith(clearMessage: true));
  }

  void _checkOutRequested(CheckOutRequested event, Emitter<MainState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      if (state.vehicleLog == null) {
        emit(MainState.error(message: 'Plate number is required', isCheckout: false));
        return;
      }



      final setup = await _setupLocalDatasource.getSetup();
      if (setup == null) {
        emit(MainState.error(message: 'Business setup not found', isCheckout: false));
        return;
      }

      VehicleLogResponseModel response =   await _vehicleRepository.checkoutVehicle(state.checkOutPlateNumber, state.paymentValue?.toInt() ?? 0);
      
      emit(state.copyWith(
        message: 'Vehicle checked out successfully', 
        messageType: MessageType.success,
        isLoading: false
      ));
    } catch (e) {
      emit(MainState.error(message: e.toString(), isCheckout: false));
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

      VehicleLogResponseModel vehicleLog = await _vehicleRepository.checkInVehicle(vehicle);
      
      // Print QR code after successful check-in
      add(PrintQRCodeRequested(state.plateNumber, vehicleLogDate: vehicleLog.entryTime));
      
      emit(state.copyWith(
        message: 'Vehicle checked in successfully',
        messageType: MessageType.success,
        isCheckin: true
      ));
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
          emit(state.copyWith(businessSetup: setup, isSetupVerified: true, isLoading: false));
        } else {
          emit(state.copyWith(isSetupRequired: true, isLoading: false));
        }
      } else {
        emit(state.copyWith(businessSetup: setup, isLoading: false));
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

      final VehicleLogResponseModel? parkingInfo = await _vehicleRepository.getCurrentParkingDurationAndCost(event.plateNumber);
      if (parkingInfo == null) {
        emit(MainState.error(message: 'Vehicle not found', isCheckout: true));
        return;
      }

      final duration = DateTime.now().difference(parkingInfo.entryTime);
      final totalMinutes = duration.inMinutes;
      
      // Business logic: Minimum charge is 1 hour, with 10 minutes grace period
      int billableHours;
      if (totalMinutes <= 70) {
        // If total time is 70 minutes or less (1 hour + 10 minutes grace), charge 1 hour
        billableHours = 1;
      } else {
        // For times over 70 minutes, calculate additional hours
        // Subtract the first 70 minutes (1 hour + 10 minutes grace)
        final remainingMinutes = totalMinutes - 70;
        // Calculate additional hours needed (rounding up)
        final additionalHours = (remainingMinutes / 60).ceil();
        billableHours = 1 + additionalHours;
      }
      
      // Get rate from business setup based on vehicle type
      final ratePerHour = parkingInfo.vehicleId.toLowerCase().contains('car') 
          ? setup.carHourCost 
          : setup.motorcycleHourCost;
      
      final paymentValue = billableHours * ratePerHour;
      final parkingTime = '${totalMinutes}m';

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



  Future<void> _handlePrintQRCode(PrintQRCodeRequested event, Emitter<MainState> emit) async {
    try {
      // Get business setup from state (optimized to avoid local storage access)
      final businessSetup = state.businessSetup;
      if (businessSetup == null) {
        emit(MainState.error(message: 'Business setup not found. Please verify setup first.'));
        return;
      }

      // Check if thermal printer is connected
      final bool isConnected = await PrintBluetoothThermal.connectionStatus;
      
      if (!isConnected) {
        emit(MainState.error(message: 'Please connect to a thermal printer first'));
        return;
      }

      // Create a generator with default profile
      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm80, profile);
      List<int> bytes = [];

      // Print business name header
      bytes += generator.text(businessSetup.businessName,
          styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          ));
      
      // Print business brand if available
      if (businessSetup.businessBrand.isNotEmpty) {
        bytes += generator.text(businessSetup.businessBrand,
            styles: const PosStyles(
              align: PosAlign.center,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            ));
      }
      
      bytes += generator.hr();

      // Print check-in header
      bytes += generator.text('ENTRADA DE VEHICULO',
          styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ));
      
      bytes += generator.hr();

      // Print plate number
      bytes += generator.text('PLACA: ${event.plateNumber.toUpperCase()}',
          styles: const PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ));

      // Print date and time
      final dateTime = event.vehicleLogDate ?? DateTime.now();
      final formattedDate = '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
      final formattedTime = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      
      bytes += generator.text('Fecha: $formattedDate',
          styles: const PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ));
      
      bytes += generator.text('Hora: $formattedTime',
          styles: const PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ));

      bytes += generator.hr();

      // Print QR code
      bytes += generator.qrcode(event.plateNumber,
          size: QRSize.size6,
          cor: QRCorrection.M);

      bytes += generator.hr();

      // Print footer
      bytes += generator.text('Bienvenido a nuestro parqueadero!',
          styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ));
      
      bytes += generator.text('Por favor, mantenga este recibo para la salida',
          styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ));
      
      bytes += generator.hr();
      
      // Print powered by footer
      bytes += generator.text('Powered by quantum-devs.xyz',
          styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ));

      // Cut paper
      bytes += generator.cut();

      // Send to printer
      await PrintBluetoothThermal.writeBytes(bytes);

      emit(state.copyWith(
        message: 'Check-in QR code printed successfully for ${event.plateNumber}',
        messageType: MessageType.success
      ));
    } catch (e) {
      _logger.e('Error printing QR code: $e');
      emit(MainState.error(message: 'Error printing QR code: $e'));
    }
  }

  void _handleQRCodeScanned(QRCodeScanned event, Emitter<MainState> emit) {
    // Set the plate number from the scanned QR code
    emit(state.copyWith(checkOutPlateNumber: event.plateNumber));
    
    // Automatically find the vehicle in parking
    add(FindVehicleInParkingRequested(event.plateNumber));
  }
} 