// Events
import 'package:equatable/equatable.dart';
import 'package:quantum_parking_flutter/features/main/data/models/active_vehicle_log_model.dart';

abstract class RecordsEvent extends Equatable {
  const RecordsEvent();

  @override
  List<Object> get props => [];
}

class SearchPlateNumberChanged extends RecordsEvent {
  final String plateNumber;

  const SearchPlateNumberChanged(this.plateNumber);

  @override
  List<Object> get props => [plateNumber];
}

class LoadRecordsRequested extends RecordsEvent {}

class GetVehicleLogsRequested extends RecordsEvent {
  final String plateNumber;

  const GetVehicleLogsRequested(this.plateNumber);

  @override
  List<Object> get props => [plateNumber];
}

class PrintRecordTicketRequested extends RecordsEvent {
  final ActiveVehicleLogModel record;

  const PrintRecordTicketRequested(this.record);

  @override
  List<Object> get props => [record];
}