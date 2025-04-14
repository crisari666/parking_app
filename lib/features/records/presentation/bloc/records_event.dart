// Events
import 'package:equatable/equatable.dart';

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