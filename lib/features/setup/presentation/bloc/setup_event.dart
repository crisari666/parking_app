import 'package:equatable/equatable.dart';

abstract class SetupEvent extends Equatable {
  const SetupEvent();

  @override
  List<Object> get props => [];
}

class SetupStarted extends SetupEvent {}

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