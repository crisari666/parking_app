// States
import 'package:equatable/equatable.dart';
import 'package:quantum_parking_flutter/features/main/data/models/vehicle_log_response_model.dart';

enum MainStateStatus {
  initial,
  loading,
  success,
  checkInSuccess,
  checkOutSuccess,
  error,
  setupRequired,
  setupVerified,
  vehicleFound,
  printerSetup;

  bool get isInitial => this == initial;
  bool get isLoading => this == loading;
  bool get isSuccess => this == success;
  bool get isCheckInSuccess => this == checkInSuccess;
  bool get isCheckOutSuccess => this == checkOutSuccess;
  bool get isError => this == error;
  bool get isSetupRequired => this == setupRequired;
  bool get isSetupVerified => this == setupVerified;
  bool get isVehicleFound => this == vehicleFound;
  bool get isPrinterSetup => this == printerSetup;
}

class MainState extends Equatable {
  final MainStateStatus status;
  final bool isLoading;
  final String? message;
  final bool isCheckin;
  final bool isCheckout;
  final String? parkingTime;
  final double? paymentValue;
  final String? paymentMethod;
  final String? printerName;
  final bool isPrinterConnected;
  final bool isSetupRequired;
  final bool isSetupVerified;
  final String plateNumber;
  final String vehicleType;
  final String checkOutPlateNumber;
  final String discount;
  final VehicleLogResponseModel? vehicleLog;

  const MainState({
    this.status = MainStateStatus.initial,
    this.isLoading = false,
    this.message,
    this.isCheckin = false,
    this.isCheckout = false,
    this.parkingTime,
    this.paymentValue,
    this.paymentMethod,
    this.printerName,
    this.isPrinterConnected = false,
    this.isSetupRequired = false,
    this.isSetupVerified = false,
    this.plateNumber = '',
    this.vehicleType = '',
    this.checkOutPlateNumber = '',
    this.discount = '0',
    this.vehicleLog,
  });

  factory MainState.initial() => const MainState();

  factory MainState.success(String message) => MainState(message: message);

  factory MainState.checkInSuccess() => const MainState(isCheckin: true);

  factory MainState.checkOutSuccess({
    required double totalCost,
    required double discount,
    required double finalCost,
  }) => MainState(
    isCheckout: true,
    paymentValue: finalCost,
  );

  factory MainState.error({
    required String message,
    bool isCheckin = false,
    bool isCheckout = false,
  }) => MainState(
    message: message,
    isCheckin: isCheckin,
    isCheckout: isCheckout,
  );

  factory MainState.setupRequired() => const MainState(isSetupRequired: true);

  factory MainState.setupVerified() => const MainState(isSetupVerified: true);

  factory MainState.printerSetup({
    String? printerName,
    bool isConnected = false,
  }) => MainState(
    printerName: printerName,
    isPrinterConnected: isConnected,
  );

  MainState copyWith({
    bool? isLoading,
    String? message,
    bool? isCheckin,
    bool? isCheckout,
    String? parkingTime,
    bool? clearParkingTime,
    double? paymentValue,
    bool? clearPaymentValue,
    String? paymentMethod,
    String? printerName,
    bool? isPrinterConnected,
    bool? isSetupRequired,
    bool? isSetupVerified,
    String? plateNumber,
    String? vehicleType,
    String? checkOutPlateNumber,
    String? discount,
    VehicleLogResponseModel? vehicleLog,
    bool? clearVehicleLog,
  }) {
    return MainState(
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      isCheckin: isCheckin ?? this.isCheckin,
      isCheckout: isCheckout ?? this.isCheckout,
      parkingTime: clearParkingTime == true ? null : parkingTime ?? this.parkingTime,
      paymentValue: clearPaymentValue == true ? null : paymentValue ?? this.paymentValue,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      printerName: printerName ?? this.printerName,
      isPrinterConnected: isPrinterConnected ?? this.isPrinterConnected,
      isSetupRequired: isSetupRequired ?? this.isSetupRequired,
      isSetupVerified: isSetupVerified ?? this.isSetupVerified,
      plateNumber: plateNumber ?? this.plateNumber,
      vehicleType: vehicleType ?? this.vehicleType,
      checkOutPlateNumber: checkOutPlateNumber ?? this.checkOutPlateNumber,
      discount: discount ?? this.discount,
      vehicleLog: clearVehicleLog == true ? null : vehicleLog ?? this.vehicleLog,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    message,
    isCheckin,
    isCheckout,
    parkingTime,
    paymentValue,
    paymentMethod,
    printerName,
    isPrinterConnected,
    isSetupRequired,
    isSetupVerified,
    plateNumber,
    vehicleType,
    checkOutPlateNumber,
    discount,
    vehicleLog,
  ];
}

// Grace time 10 min
// Metodo de pago
// Mostrar