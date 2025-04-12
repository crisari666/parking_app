import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Models
class VehicleRecord extends Equatable {
  final String plateNumber;
  final String vehicleType;
  final DateTime checkIn;
  final DateTime? checkOut;
  final double? totalCost;

  const VehicleRecord({
    required this.plateNumber,
    required this.vehicleType,
    required this.checkIn,
    this.checkOut,
    this.totalCost,
  });

  @override
  List<Object?> get props => [
        plateNumber,
        vehicleType,
        checkIn,
        checkOut,
        totalCost,
      ];
}

// Events
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

// States
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

// Bloc
class RecordsBloc extends Bloc<RecordsEvent, RecordsState> {
  RecordsBloc() : super(RecordsInitial()) {
    on<SearchPlateNumberChanged>((event, emit) {
      // Handle search plate number change
    });
    on<LoadRecordsRequested>((event, emit) async {
      emit(RecordsLoading());
      try {
        // TODO: Implement records loading logic
        emit(const RecordsSuccess([]));
      } catch (e) {
        emit(RecordsError(e.toString()));
      }
    });
  }
} 