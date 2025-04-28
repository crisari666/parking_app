// States
import 'package:equatable/equatable.dart';
import 'package:quantum_parking_flutter/features/records/data/models/daily_closure_model.dart';

abstract class ClosureState extends Equatable {
  const ClosureState();

  @override
  List<Object?> get props => [];
}

class ClosureInitial extends ClosureState {}

class ClosureLoading extends ClosureState {}

class ClosureSuccess extends ClosureState {
  final DailyClosureModel closure;

  const ClosureSuccess(this.closure);

  @override
  List<Object?> get props => [closure];
}

class ClosuresLoaded extends ClosureState {
  final List<DailyClosureModel> closures;

  const ClosuresLoaded(this.closures);

  @override
  List<Object?> get props => [closures];
}

class ClosureError extends ClosureState {
  final String message;

  const ClosureError(this.message);

  @override
  List<Object?> get props => [message];
}