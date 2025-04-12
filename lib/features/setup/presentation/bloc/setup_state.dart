import 'package:equatable/equatable.dart';
import 'package:quantum_parking_flutter/features/setup/data/models/business_setup_model.dart';

// States
abstract class SetupState extends Equatable {
  const SetupState();

  @override
  List<Object> get props => [];
}

class SetupInitial extends SetupState {}

class SetupLoading extends SetupState {}
class SetupSuccess extends SetupState {
  final BusinessSetupModel? setup;
  final bool isFromSave;
  
  const SetupSuccess(this.setup, {this.isFromSave = false});

  @override
  List<Object> get props => [if (setup != null) setup!];
}

class SetupError extends SetupState {
  final String message;

  const SetupError(this.message);

  @override
  List<Object> get props => [message];
}