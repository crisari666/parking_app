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
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr/qr.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';

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
      
      emit(state.copyWith(message: 'Vehicle checked out successfully', isLoading: false));
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

      await _vehicleRepository.checkInVehicle(vehicle);
      
      // Print QR code after successful check-in
      add(PrintQRCodeRequested(state.plateNumber));
      
      emit(state.copyWith(isCheckin: true));
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

  Future<Uint8List> _generateQrCodeImage(String data) async {
    final qrCode = QrCode.fromData(
      data: data,
      errorCorrectLevel: QrErrorCorrectLevel.M,
    );

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    final painter = QrPainter.withQr(
      qr: qrCode,
      color: const Color(0xFF000000),
      gapless: true,
    );

    const size = 200.0;
    painter.paint(canvas, const ui.Size(size, size));

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<void> _handlePrintQRCode(PrintQRCodeRequested event, Emitter<MainState> emit) async {
    try {
      // Get business setup from state (optimized to avoid local storage access)
      final businessSetup = state.businessSetup;
      if (businessSetup == null) {
        emit(MainState.error(message: 'Business setup not found. Please verify setup first.'));
        return;
      }

      final qrBytes = await _generateQrCodeImage(event.plateNumber);
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.roll80,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                // Business name at the top
                pw.Text(
                  businessSetup.businessName,
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                if (businessSetup.businessBrand.isNotEmpty) ...[
                  pw.SizedBox(height: 8),
                  pw.Text(
                    businessSetup.businessBrand,
                    style: const pw.TextStyle(fontSize: 16),
                  ),
                ],
                pw.SizedBox(height: 20),
                pw.Divider(thickness: 2),
                pw.SizedBox(height: 10),
                // Check-in header
                pw.Text(
                  'VEHICLE CHECK-IN',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                // Plate number
                pw.Text(
                  'Plate: ${event.plateNumber}',
                  style: const pw.TextStyle(fontSize: 16),
                ),
                pw.SizedBox(height: 5),
                // Date and time
                pw.Text(
                  'Date: ${DateTime.now().toString().substring(0, 19)}',
                  style: const pw.TextStyle(fontSize: 14),
                ),
                pw.SizedBox(height: 20),
                // QR Code
                pw.Image(
                  pw.MemoryImage(qrBytes),
                  width: 200,
                  height: 200,
                ),
                pw.SizedBox(height: 20),
                pw.Divider(thickness: 2),
                pw.SizedBox(height: 10),
                // Footer messages
                pw.Text(
                  'Welcome to our parking!',
                  style: const pw.TextStyle(fontSize: 14),
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  'Please keep this receipt for checkout',
                  style: const pw.TextStyle(fontSize: 12),
                ),
              ],
            );
          },
        ),
      );

      final pdfBytes = await pdf.save();

      // Try to print using available printers
      final printers = await Printing.listPrinters();
      _logger.d('Available printers: $printers');

      if (printers.isNotEmpty) {
        // Try to use the first available printer
        try {
          await Printing.directPrintPdf(
            printer: printers.first,
            onLayout: (format) async => pdfBytes,
          );
          
          emit(state.copyWith(message: 'Check-in QR code printed successfully for ${event.plateNumber}'));
        } catch (e) {
          _logger.e('Error in direct printing: $e');
          // Fallback to normal printing dialog
          await Printing.layoutPdf(
            onLayout: (format) async => pdfBytes,
          );
          emit(state.copyWith(message: 'Check-in QR code ready for printing for ${event.plateNumber}'));
        }
      } else {
        // No printers available, show printing dialog
        await Printing.layoutPdf(
          onLayout: (format) async => pdfBytes,
        );
        emit(MainState.success('Check-in QR code ready for printing for ${event.plateNumber}'));
      }
    } catch (e) {
      _logger.e('Error printing QR code: $e');
      emit(MainState.error(message: 'Error printing QR code: $e'));
    }
  }
} 