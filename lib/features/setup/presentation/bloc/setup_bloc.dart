import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class SetupEvent extends Equatable {
  const SetupEvent();

  @override
  List<Object> get props => [];
}

class BusinessNameChanged extends SetupEvent {
  final String name;

  const BusinessNameChanged(this.name);

  @override
  List<Object> get props => [name];
}

class BusinessBrandChanged extends SetupEvent {
  final String brand;

  const BusinessBrandChanged(this.brand);

  @override
  List<Object> get props => [brand];
}

class CarHourCostChanged extends SetupEvent {
  final String cost;

  const CarHourCostChanged(this.cost);

  @override
  List<Object> get props => [cost];
}

class MotorcycleHourCostChanged extends SetupEvent {
  final String cost;

  const MotorcycleHourCostChanged(this.cost);

  @override
  List<Object> get props => [cost];
}

class CarMonthlyCostChanged extends SetupEvent {
  final String cost;

  const CarMonthlyCostChanged(this.cost);

  @override
  List<Object> get props => [cost];
}

class MotorcycleMonthlyCostChanged extends SetupEvent {
  final String cost;

  const MotorcycleMonthlyCostChanged(this.cost);

  @override
  List<Object> get props => [cost];
}

class SetupSubmitted extends SetupEvent {}

// States
abstract class SetupState extends Equatable {
  const SetupState();

  @override
  List<Object> get props => [];
}

class SetupInitial extends SetupState {}

class SetupLoading extends SetupState {}

class SetupSuccess extends SetupState {}

class SetupError extends SetupState {
  final String message;

  const SetupError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class SetupBloc extends Bloc<SetupEvent, SetupState> {
  SetupBloc() : super(SetupInitial()) {
    on<BusinessNameChanged>((event, emit) {
      // Handle business name change
    });
    on<BusinessBrandChanged>((event, emit) {
      // Handle business brand change
    });
    on<CarHourCostChanged>((event, emit) {
      // Handle car hour cost change
    });
    on<MotorcycleHourCostChanged>((event, emit) {
      // Handle motorcycle hour cost change
    });
    on<CarMonthlyCostChanged>((event, emit) {
      // Handle car monthly cost change
    });
    on<MotorcycleMonthlyCostChanged>((event, emit) {
      // Handle motorcycle monthly cost change
    });
    on<SetupSubmitted>((event, emit) async {
      emit(SetupLoading());
      try {
        // TODO: Implement setup save logic
        emit(SetupSuccess());
      } catch (e) {
        emit(SetupError(e.toString()));
      }
    });
  }
} 