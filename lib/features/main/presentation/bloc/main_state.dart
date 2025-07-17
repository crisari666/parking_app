// States
import 'package:equatable/equatable.dart';
import 'package:quantum_parking_flutter/features/main/data/models/vehicle_log_response_model.dart';
import 'package:quantum_parking_flutter/features/setup/data/models/business_setup_model.dart';

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

enum MessageType {
  success,
  error,
  warning,
  info,
}

class MainState extends Equatable {
  final MainStateStatus status;
  final bool isLoading;
  final String? message;
  final MessageType? messageType;
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
  final bool isStudentRate;
  final VehicleLogResponseModel? vehicleLog;
  final BusinessSetupModel? businessSetup;

  const MainState({
    this.status = MainStateStatus.initial,
    this.isLoading = false,
    this.message,
    this.messageType,
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
    this.isStudentRate = false,
    this.vehicleLog,
    this.businessSetup,
  });

  factory MainState.initial() => const MainState();

  factory MainState.success(String message) => MainState(message: message, messageType: MessageType.success);


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
    messageType: MessageType.error,
    isCheckin: isCheckin,
    isCheckout: isCheckout,
  );

  MainState copyWith({
    bool? isLoading,
    bool? clearMessage,
    String? message,
    MessageType? messageType,
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
    bool? isStudentRate,
    VehicleLogResponseModel? vehicleLog,
    bool? clearVehicleLog,
    BusinessSetupModel? businessSetup,
  }) {
    return MainState(
      isLoading: isLoading ?? this.isLoading,
      message: clearMessage == true ? null : message ?? this.message,
      messageType: clearMessage == true ? null : messageType ?? this.messageType,
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
      isStudentRate: isStudentRate ?? this.isStudentRate,
      vehicleLog: clearVehicleLog == true ? null : vehicleLog ?? this.vehicleLog,
      businessSetup: businessSetup ?? this.businessSetup,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    message,
    messageType,
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
    isStudentRate,
    vehicleLog,
    businessSetup,
  ];
}

// Grace time 10 min
// Metodo de pago
// Mostrar