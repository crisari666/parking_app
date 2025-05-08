import 'package:equatable/equatable.dart';

abstract class SetupEvent extends Equatable {
  const SetupEvent();

  @override
  List<Object> get props => [];
}

class SetupStarted extends SetupEvent {}

class SetupBusinessNameChanged extends SetupEvent {
  final String name;

  const SetupBusinessNameChanged(this.name);

  @override
  List<Object> get props => [name];
}

class SetupBusinessBrandChanged extends SetupEvent {
  final String brand;

  const SetupBusinessBrandChanged(this.brand);

  @override
  List<Object> get props => [brand];
}

class SetupCarHourCostChanged extends SetupEvent {
  final String cost;

  const SetupCarHourCostChanged(this.cost);

  @override
  List<Object> get props => [cost];
}

class SetupMotorcycleHourCostChanged extends SetupEvent {
  final String cost;

  const SetupMotorcycleHourCostChanged(this.cost);

  @override
  List<Object> get props => [cost];
}

class SetupCarMonthlyCostChanged extends SetupEvent {
  final String cost;

  const SetupCarMonthlyCostChanged(this.cost);

  @override
  List<Object> get props => [cost];
}

class SetupMotorcycleMonthlyCostChanged extends SetupEvent {
  final String cost;

  const SetupMotorcycleMonthlyCostChanged(this.cost);

  @override
  List<Object> get props => [cost];
}

class SetupCarDayCostChanged extends SetupEvent {
  final String cost;

  const SetupCarDayCostChanged(this.cost);

  @override
  List<Object> get props => [cost];
}

class SetupMotorcycleDayCostChanged extends SetupEvent {
  final String cost;

  const SetupMotorcycleDayCostChanged(this.cost);

  @override
  List<Object> get props => [cost];
}

class SetupSubmitted extends SetupEvent {} 