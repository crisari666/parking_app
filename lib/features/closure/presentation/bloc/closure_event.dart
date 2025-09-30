// Events
import 'package:equatable/equatable.dart';

abstract class ClosureEvent extends Equatable {
  const ClosureEvent();

  @override
  List<Object?> get props => [];
}

class GenerateDailyClosureRequested extends ClosureEvent {}

class LoadDailyClosuresRequested extends ClosureEvent {}

class ClosureDateChanged extends ClosureEvent {
  final DateTime selectedDate;

  const ClosureDateChanged(this.selectedDate);

  @override
  List<Object?> get props => [selectedDate];
}

class GetClosureDataByDate extends ClosureEvent {
  final DateTime date;

  const GetClosureDataByDate(this.date);

  @override
  List<Object?> get props => [date];
}

class GetFinancialResumeByDate extends ClosureEvent {
  final DateTime date;

  const GetFinancialResumeByDate(this.date);

  @override
  List<Object?> get props => [date];
}