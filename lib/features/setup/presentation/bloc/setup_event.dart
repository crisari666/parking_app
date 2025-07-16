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

class SetupCarNightCostChanged extends SetupEvent {
  final String cost;

  const SetupCarNightCostChanged({required this.cost});

  @override
  List<Object> get props => [cost];
}

class SetupMotorcycleNightCostChanged extends SetupEvent {
  final String cost;

  const SetupMotorcycleNightCostChanged({required this.cost});

  @override
  List<Object> get props => [cost];
}

class SetupStudentMotorcycleHourCostChanged extends SetupEvent {
  final String cost;

  const SetupStudentMotorcycleHourCostChanged({required this.cost});

  @override
  List<Object> get props => [cost];
}

class SetupFetchBusinesses extends SetupEvent {}

class SetupBusinessNitChanged extends SetupEvent {
  final String nit;

  const SetupBusinessNitChanged({required this.nit});

  @override
  List<Object> get props => [nit];
}

class SetupBusinessResolutionChanged extends SetupEvent {
  final String resolution;

  const SetupBusinessResolutionChanged({required this.resolution});

  @override
  List<Object> get props => [resolution];
}

class SetupAddressChanged extends SetupEvent {
  final String address;

  const SetupAddressChanged({required this.address});

  @override
  List<Object> get props => [address];
}

class SetupScheduleChanged extends SetupEvent {
  final String schedule;

  const SetupScheduleChanged({required this.schedule});

  @override
  List<Object> get props => [schedule];
} 