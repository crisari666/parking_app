import 'package:equatable/equatable.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/models/vehicle_record.dart';

enum RecordsStatus {
  initial,
  loading,
  success,
  error;

  bool get isLoading => this == loading;
  bool get isSuccess => this == success;
  bool get isError => this == error;
}

class RecordsState extends Equatable {

  final RecordsStatus status;
  final List<VehicleRecord> records;
  final List<VehicleRecord>? vehicleLogs;
  final String? errorMessage;

  const RecordsState({
    this.status = RecordsStatus.initial,
    this.records = const [],
    this.vehicleLogs,
    this.errorMessage,
  });

  factory RecordsState.initial() => const RecordsState();

  factory RecordsState.loading() => const RecordsState(status: RecordsStatus.loading);

  factory RecordsState.success(List<VehicleRecord> records, {List<VehicleRecord>? vehicleLogs}) => 
    RecordsState(records: records, vehicleLogs: vehicleLogs, status: RecordsStatus.success);

  factory RecordsState.error(String message) => 
    RecordsState(errorMessage: message);

  RecordsState copyWith({
    RecordsStatus? status,
    List<VehicleRecord>? records,
    List<VehicleRecord>? vehicleLogs,
    String? errorMessage,
  }) {
    return RecordsState(
      status: status ?? this.status,
      records: records ?? this.records,
      vehicleLogs: vehicleLogs ?? this.vehicleLogs,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, records, vehicleLogs, errorMessage];
}