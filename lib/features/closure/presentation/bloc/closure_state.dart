// States
import 'package:equatable/equatable.dart';
import 'package:quantum_parking_flutter/features/records/data/models/daily_closure_model.dart';
import 'package:quantum_parking_flutter/features/records/data/models/financial_resume_model.dart';

enum ClosureStatus {
  initial,
  loading,
  success,
  error;

  bool get isLoading => this == ClosureStatus.loading;
  bool get isInitial => this == ClosureStatus.initial;
  bool get isSuccess => this == ClosureStatus.success;
  bool get isError => this == ClosureStatus.error;
}

class ClosureState extends Equatable {
  final ClosureStatus status;
  final DailyClosureModel? closure;
  final List<DailyClosureModel>? closures;
  final FinancialResumeModel? financialResume;
  final String? errorMessage;

  const ClosureState({
    this.status = ClosureStatus.initial,
    this.closure,
    this.closures,
    this.financialResume,
    this.errorMessage,
  });

  ClosureState copyWith({
    ClosureStatus? status,
    DailyClosureModel? closure,
    List<DailyClosureModel>? closures,
    FinancialResumeModel? financialResume,
    String? errorMessage,
  }) {
    return ClosureState(
      status: status ?? this.status,
      closure: closure ?? this.closure,
      closures: closures ?? this.closures,
      financialResume: financialResume ?? this.financialResume,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory ClosureState.initial() => const ClosureState();

  factory ClosureState.loading() => const ClosureState(status: ClosureStatus.loading);

  factory ClosureState.success(DailyClosureModel closure) => ClosureState(
        status: ClosureStatus.success,
        closure: closure,
      );

  factory ClosureState.closuresLoaded(List<DailyClosureModel> closures) => ClosureState(
        status: ClosureStatus.success,
        closures: closures,
      );

  factory ClosureState.error(String message) => ClosureState(
        status: ClosureStatus.error,
        errorMessage: message,
      );

  @override
  List<Object?> get props => [status, closure, closures, financialResume, errorMessage];
}