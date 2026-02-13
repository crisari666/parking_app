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
import 'package:quantum_parking_flutter/core/utils/date_time_service.dart';
import 'package:quantum_parking_flutter/core/services/ticket_printer_service.dart';
import 'package:logger/logger.dart';
import 'package:quantum_parking_flutter/core/utils/parking_rate_calculator.dart';

// Bloc
class MainBloc extends Bloc<MainEvent, MainState> {
  final VehicleRepository _vehicleRepository;
  final SetupLocalDatasource _setupLocalDatasource;
  final BusinessRemoteDatasource _businessRemoteDatasource;
  final PrinterRepository _printerRepository;
  final TicketPrinterService _ticketPrinterService;
  final Logger _logger = Logger();
  StreamSubscription<PrinterConnectionState>? _printerConnectionSubscription;
  double? _paymentValue;

  MainBloc({
    required LocalStorageService localStorageService,
    required SetupLocalDatasource setupLocalDatasource,
    required BusinessRemoteDatasource businessRemoteDatasource,
    required VehicleRepository vehicleRepository,
    required PrinterRepository printerRepository,
    required TicketPrinterService ticketPrinterService,
  }) : 
       _setupLocalDatasource = setupLocalDatasource,
       _businessRemoteDatasource = businessRemoteDatasource,
       _vehicleRepository = vehicleRepository,
       _printerRepository = printerRepository,
       _ticketPrinterService = ticketPrinterService,
       super(MainState.initial()) {
    on<PlateNumberChanged>(_handlePlateNumberChanged);
    on<VehicleTypeChanged>(_handleVehicleTypeChanged);
    on<CheckInRequested>(_checkInRequested);
    on<CheckOutPlateNumberChanged>(_handleCheckOutPlateNumberChanged);
    on<DiscountChanged>(_handleDiscountChanged);
    on<StudentRateChanged>(_handleStudentRateChanged);
    on<CheckOutRequested>(_checkOutRequested);
    on<VerifySetupRequested>(_verifySetup);
    on<PaymentMethodChanged>(_handlePaymentMethodChanged);
    on<FindVehicleInParkingRequested>(_findVehicleInParking);
    on<PrinterSetupRequested>(_handlePrinterSetup);
    on<CheckOutPaymentValueChanged>(_handleCheckOutPaymentValueChanged);
    on<ResetCheckOutForm>(_handleResetCheckOutForm);
    on<PrintQRCodeRequested>(_handlePrintQRCode);
    on<PrintCheckOutReceiptRequested>(_handlePrintCheckOutReceipt);
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

  void _handleStudentRateChanged(StudentRateChanged event, Emitter<MainState> emit) {
    emit(state.copyWith(isStudentRate: event.isStudentRate));
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

      // Use the new consolidated checkout method that returns CheckOutData
      final checkOutData = await _vehicleRepository.checkoutVehicleWithData(
        state.checkOutPlateNumber, 
        state.paymentValue?.toInt() ?? 0,
        discount: state.discount.isNotEmpty ? double.tryParse(state.discount) : null,
        paymentMethod: state.paymentMethod,
      );
      
      emit(state.copyWith(
        isCheckout: true,
        message: 'Salida de vehiculo exitosa.', 
        messageType: MessageType.success,
        isLoading: false
      ));
      
      // Print check-out receipt after successful check-out if requested
      // Use the consistent data from the backend response
      if (event.shouldPrint) {
        add(PrintCheckOutReceiptRequested(
          plateNumber: checkOutData.plateNumber,
        checkInTime: DateTimeService.fromUtc(checkOutData.checkInTime),
          checkOutTime: checkOutData.checkOutTime,
          totalCost: checkOutData.finalCost,
          vehicleType: checkOutData.vehicleType,
          discount: checkOutData.discount,
          paymentMethod: checkOutData.paymentMethodDisplay,
        ));
      }
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
        checkIn: DateTimeService.now(),
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

      final duration = DateTimeService.now().difference(parkingInfo.entryTime);
      final totalMinutes = duration.inMinutes;

      // Calculate payment value - no charge for vehicles with active membership
      final paymentValue = parkingInfo.hasMembership 
          ? 0.0  // No charge for vehicles with active membership
          : ParkingRateCalculator.calculateParkingCost(
              totalMinutes: totalMinutes,
              vehicleType: parkingInfo.vehicleType,
              businessSetup: setup,
              isStudentRate: state.isStudentRate,
            );
      final parkingTime = ParkingRateCalculator.getParkingTimeString(totalMinutes);

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

      // Use the centralized ticket printer service
      final success = await _ticketPrinterService.printCheckInTicket(
        plateNumber: event.plateNumber,
        businessSetup: businessSetup,
        checkInTime: event.vehicleLogDate != null 
            ? DateTimeService.fromUtc(event.vehicleLogDate!) 
            : null,
        vehicleType: state.vehicleType.isNotEmpty ? state.vehicleType : null,
      );

      if (success) {
        emit(state.copyWith(
          message: 'QR de entrada impreso correctamente para ${event.plateNumber}',
          messageType: MessageType.success
        ));
      } else {
        emit(MainState.error(message: 'Error al imprimir el QR: No se pudo conectar con la impresora'));
      }
    } catch (e) {
      _logger.e('Error printing QR code: $e');
      emit(MainState.error(message: 'Error al imprimir el QR: $e'));
    }
  }

  Future<void> _handlePrintCheckOutReceipt(PrintCheckOutReceiptRequested event, Emitter<MainState> emit) async {
    try {
      // Get business setup from state
      final businessSetup = state.businessSetup;
      if (businessSetup == null) {
        emit(MainState.error(message: 'Configuración de negocio no encontrada. Por favor, verifique la configuración primero.'));
        return;
      }

      // Use the centralized ticket printer service
      final success = await _ticketPrinterService.printCheckOutReceipt(
        plateNumber: event.plateNumber,
        businessSetup: businessSetup,
        checkInTime: event.checkInTime,
        checkOutTime: event.checkOutTime,
        totalCost: event.totalCost,
        vehicleType: event.vehicleType,
        discount: event.discount,
        paymentMethod: event.paymentMethod,
      );

      if (success) {
        emit(state.copyWith(
          message: 'Recibo de salida impreso correctamente para ${event.plateNumber}',
          messageType: MessageType.success
        ));
      } else {
        emit(MainState.error(message: 'Error al imprimir el recibo: No se pudo conectar con la impresora'));
      }
    } catch (e) {
      _logger.e('Error printing check-out receipt: $e');
      emit(MainState.error(message: 'Error al imprimir el recibo: $e'));
    }
  }

  void _handleQRCodeScanned(QRCodeScanned event, Emitter<MainState> emit) {
    // Set the plate number from the scanned QR code
    emit(state.copyWith(checkOutPlateNumber: event.plateNumber));
    
    // Automatically find the vehicle in parking
    add(FindVehicleInParkingRequested(event.plateNumber));
  }

  Future<void> _handleCheckPrinterConnectionStatus(
    CheckPrinterConnectionStatus event,
    Emitter<MainState> emit,
  ) async {
    try {
      // Try to connect to stored printer if any; then current status
      // is reflected via the connection state stream.
      await _printerRepository.ensureStoredPrinterConnected();
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