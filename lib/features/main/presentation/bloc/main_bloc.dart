import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:quantum_parking_flutter/features/main/data/datasources/local_storage_service.dart';
import 'package:quantum_parking_flutter/features/main/data/models/vehicle_log_response_model.dart';
import 'package:quantum_parking_flutter/features/main/data/models/vehicle_model.dart';
import 'package:quantum_parking_flutter/features/main/data/repositories/printer_repository.dart';
import 'package:quantum_parking_flutter/features/main/domain/repositories/vehicle_repository.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_event.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_state.dart';
import 'package:quantum_parking_flutter/features/setup/data/datasources/business_remote_datasource.dart';
import 'package:quantum_parking_flutter/features/setup/data/datasources/setup_local_datasource.dart';
import 'package:logger/logger.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';

// Bloc
class MainBloc extends Bloc<MainEvent, MainState> {
  final VehicleRepository _vehicleRepository;
  final LocalStorageService _localStorageService;
  final SetupLocalDatasource _setupLocalDatasource;
  final BusinessRemoteDatasource _businessRemoteDatasource;
  final PrinterRepository _printerRepository;
  final Logger _logger = Logger();
  StreamSubscription<PrinterConnectionState>? _printerConnectionSubscription;
  double? _paymentValue;

  MainBloc({
    required LocalStorageService localStorageService,
    required SetupLocalDatasource setupLocalDatasource,
    required BusinessRemoteDatasource businessRemoteDatasource,
    required VehicleRepository vehicleRepository,
    required PrinterRepository printerRepository,
  }) : _localStorageService = localStorageService,
       _setupLocalDatasource = setupLocalDatasource,
       _businessRemoteDatasource = businessRemoteDatasource,
       _vehicleRepository = vehicleRepository,
       _printerRepository = printerRepository,
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
    on<ClearChecksForm>(_handleClearChecksForm);
    on<CheckPrinterConnectionStatus>(_handleCheckPrinterConnectionStatus);
    on<PerformPrinterHardwareTest>(_handlePerformPrinterHardwareTest);
    
    // Listen to printer connection state changes
    _printerConnectionSubscription = _printerRepository.connectionStateStream.listen(
      (printerState) {
        emit(state.copyWith(
          isPrinterConnected: printerState.isConnected,
          printerName: printerState.printerName,
        ));
      },
      onError: (error) {
        _logger.e('Error in printer connection stream: $error');
      },
    );
  }

  @override
  Future<void> close() {
    _printerConnectionSubscription?.cancel();
    return super.close();
  }

  void _handleClearChecksForm(ClearChecksForm event, Emitter<MainState> emit) {
    emit(state.copyWith(
      isCheckin: false,
      isCheckout: false,
      isLoading: false,
      message: null,
      messageType: null,
      plateNumber: '',
      vehicleType: '',
    ));
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
    // This method is now handled by the printer repository stream
    // The printer connection state will be updated automatically via the stream
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
        emit(MainState.error(message: 'Placa requerida', isCheckout: false));
        return;
      }



      final setup = await _setupLocalDatasource.getSetup();
      if (setup == null) {
        emit(MainState.error(message: 'Configuración de negocio no encontrada', isCheckout: false));
        return;
      }

      VehicleLogResponseModel response =   await _vehicleRepository.checkoutVehicle(state.checkOutPlateNumber, state.paymentValue?.toInt() ?? 0);
      
      emit(state.copyWith(
        isCheckout: true,
        message: 'Salida de vehiculo exitosa.', 
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
        emit(MainState.error(message: 'Placa y tipo de vehiculo requeridos', isCheckin: true));
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
        message: 'Registro de ingreso exitoso.',
        messageType: MessageType.success,
        isLoading: false,
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
        emit(MainState.error(message: 'Configuración de negocio no encontrada', isCheckout: false));
        return;
      }

      final VehicleLogResponseModel? parkingInfo = await _vehicleRepository.getCurrentParkingDurationAndCost(event.plateNumber);
      if (parkingInfo == null || parkingInfo.exitTime != null) {
        emit(MainState.error(message: 'Vehiculo no encontrado', isCheckout: false));
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
      final ratePerHour = parkingInfo.vehicleType.toLowerCase().contains('car') 
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
        emit(MainState.error(message: 'Configuración de negocio no encontrada. Por favor, verifique la configuración primero.'));
        return;
      }

      // Check if thermal printer is connected
      final bool isConnected = await PrintBluetoothThermal.connectionStatus;
      
      if (!isConnected) {
        //emit(MainState.error(message: 'Please connect to a thermal printer first'));
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
      
      bytes += generator.emptyLines(1);

      // Print check-in header
      bytes += generator.text('ENTRADA DE VEHICULO',
          styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ));
      
      bytes += generator.emptyLines(1);

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

      bytes += generator.emptyLines(1);

      // Print QR code
      bytes += generator.qrcode(event.plateNumber,
          size: QRSize.size6,
          cor: QRCorrection.M);

      bytes += generator.emptyLines(1);

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
      
      bytes += generator.emptyLines(1);
      
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
        message: 'QR de entrada impreso correctamente para ${event.plateNumber}',
        messageType: MessageType.success
      ));
    } catch (e) {
      _logger.e('Error printing QR code: $e');
      emit(MainState.error(message: 'Error al imprimir el QR: $e'));
    }
  }

  void _handleQRCodeScanned(QRCodeScanned event, Emitter<MainState> emit) {
    // Set the plate number from the scanned QR code
    emit(state.copyWith(checkOutPlateNumber: event.plateNumber));
    
    // Automatically find the vehicle in parking
    add(FindVehicleInParkingRequested(event.plateNumber));
  }

  Future<void> _handleCheckPrinterConnectionStatus(CheckPrinterConnectionStatus event, Emitter<MainState> emit) async {
    try {
      final bool isConnected = await _printerRepository.checkCurrentConnectionStatus();
      
      // The state will be updated automatically via the stream subscription
      // No need to manually emit here as the stream will handle it
    } catch (e) {
      _logger.e('Error checking printer connection status: $e');
    }
  }

  Future<void> _handlePerformPrinterHardwareTest(PerformPrinterHardwareTest event, Emitter<MainState> emit) async {
    try {
      final bool testPassed = await _printerRepository.checkCurrentConnectionStatus();
      
      if (testPassed) {
        emit(state.copyWith(
          message: 'Prueba de hardware de impresora pasada',
          messageType: MessageType.success,
        ));
      } else {
        emit(state.copyWith(
          message: 'Prueba de hardware de impresora fallida - la impresora puede estar desconectada',
          messageType: MessageType.warning,
        ));
      }
    } catch (e) {
      _logger.e('Error performing printer hardware test: $e');
      emit(state.copyWith(
        message: 'Error performing printer hardware test: $e',
        messageType: MessageType.error,
      ));
    }
  }
} 