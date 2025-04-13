import 'package:equatable/equatable.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/models/vehicle_record.dart';

abstract class RecordsState extends Equatable {
  const RecordsState();

  @override
  List<Object> get props => [];
}

class RecordsInitial extends RecordsState {}

class RecordsLoading extends RecordsState {}

class RecordsSuccess extends RecordsState {
  final List<VehicleRecord> records;

  const RecordsSuccess(this.records);

  @override
  List<Object> get props => [records];
}

class RecordsError extends RecordsState {
  final String message;

  const RecordsError(this.message);

  @override
  List<Object> get props => [message];
}