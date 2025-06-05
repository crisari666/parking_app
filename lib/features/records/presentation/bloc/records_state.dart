import 'package:equatable/equatable.dart';
import 'package:quantum_parking_flutter/features/main/data/models/active_vehicle_log_model.dart';
import 'package:quantum_parking_flutter/features/main/data/models/vehicle_log_response_model.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/models/vehicle_record.dart';

enum RecordsStatus {
  initial,
  loading,
  success,
  error;

  bool get isLoading => this == loading;
  bool get isSuccess => this == success;
  bool get isError => this == error;
  bool get isInitial => this == initial;
}

class RecordsState extends Equatable {

  final RecordsStatus status;
  final List<VehicleRecord> records;
  final List<VehicleLogResponseModel>? vehicleLogs;
  final List<ActiveVehicleLogModel> logs;
  final String? errorMessage;
  final bool isLoadingLogs;

  const RecordsState({
    this.status = RecordsStatus.initial,
    this.records = const [],
    this.vehicleLogs,
    this.logs = const [],
    this.errorMessage,
    this.isLoadingLogs = false,
  });

  factory RecordsState.initial() => const RecordsState();

  factory RecordsState.loading() => const RecordsState(status: RecordsStatus.loading);

  factory RecordsState.success(List<VehicleRecord> records, {List<VehicleLogResponseModel> vehicleLogs = const [], List<ActiveVehicleLogModel> logs = const []}) => 
    RecordsState(
      records: records, 
      vehicleLogs: vehicleLogs, 
      logs: logs, 
      status: RecordsStatus.success
    );


  factory RecordsState.error(String message) => 
    RecordsState(errorMessage: message);

  RecordsState copyWith({
    RecordsStatus? status,
    List<VehicleRecord>? records,
    List<VehicleLogResponseModel>? vehicleLogs,
    String? errorMessage,
    List<ActiveVehicleLogModel>? logs,
    bool? isLoadingLogs,
  }) {
    return RecordsState(
      status: status ?? this.status,
      records: records ?? this.records,
      vehicleLogs: vehicleLogs ?? this.vehicleLogs,
      errorMessage: errorMessage ?? this.errorMessage,
      logs: logs ?? this.logs,
      isLoadingLogs: isLoadingLogs ?? this.isLoadingLogs,
    );
  }

  @override
  List<Object?> get props => [status, records, vehicleLogs, errorMessage, logs, isLoadingLogs];
}