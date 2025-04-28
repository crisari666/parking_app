// Events
import 'package:equatable/equatable.dart';

abstract class ClosureEvent extends Equatable {
  const ClosureEvent();

  @override
  List<Object?> get props => [];
}

class GenerateDailyClosureRequested extends ClosureEvent {}

class LoadDailyClosuresRequested extends ClosureEvent {}