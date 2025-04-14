import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/records_bloc.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/records_state.dart';
import 'package:quantum_parking_flutter/features/records/presentation/widgets/record_item.dart';
import 'package:quantum_parking_flutter/features/records/presentation/widgets/vehicle_logs_dialog.dart';

class RecordsList extends StatelessWidget {
  const RecordsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RecordsBloc, RecordsState>(
      listener: (context, state) {
        if (state is RecordsSuccess && state.vehicleLogs != null) {
          showDialog(
              context: context,
              builder: (context) => BlocBuilder<RecordsBloc, RecordsState>(
                builder: (context, state) {
                    return VehicleLogsDialog(
                      logs: (state as RecordsSuccess).vehicleLogs!,
                      plateNumber: state.records[0].plateNumber,
                    );
                  }
              ),
            );
        }
      },
      builder: (context, state) {
        if (state is RecordsSuccess) {
          return ListView.builder(
            itemCount: state.records.length,
            itemBuilder: (context, index) {
              final record = state.records[index];
              return RecordItem(record: record);
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
} 