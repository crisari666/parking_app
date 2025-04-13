import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/records_event.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/records_state.dart';

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