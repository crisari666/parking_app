import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/records_bloc.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/records_state.dart';
import 'package:quantum_parking_flutter/features/records/presentation/widgets/record_item.dart';

class RecordsList extends StatelessWidget {
  const RecordsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecordsBloc, RecordsState>(
      builder: (context, state) {
        if (state is RecordsSuccess) {
          return ListView.builder(
            itemCount: state.records.length,
            itemBuilder: (context, index) {
              final record = state.records[index];
              // Get all records for this vehicle's plate number
              final pastLogs = state.records
                  .where((r) => r.plateNumber == record.plateNumber)
                  .toList();
              return RecordItem(
                record: record,
                pastLogs: pastLogs,
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
} 