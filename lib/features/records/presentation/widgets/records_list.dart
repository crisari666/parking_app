import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/records_bloc.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/records_state.dart';
import 'package:quantum_parking_flutter/features/records/presentation/widgets/record_item.dart';

class RecordsList extends StatelessWidget {
  const RecordsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RecordsBloc, RecordsState>(
      buildWhen: (previous, current) => previous.logs != current.logs,
      listener: (context, state) {
      },
      builder: (context, state) {
        if (state.status == RecordsStatus.success) {
          return ListView.builder(
            itemCount: state.logs.length,
            itemBuilder: (context, index) {
              final record = state.logs[index];
              return RecordItem(record: record);
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
} 