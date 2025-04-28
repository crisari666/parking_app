import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/records_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/records_event.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/records_state.dart';
import 'package:quantum_parking_flutter/features/records/presentation/widgets/records_list.dart';
import 'package:quantum_parking_flutter/l10n/app_localizations_context.dart';

@RoutePage()
class RecordsPage extends StatelessWidget {
  const RecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<RecordsBloc>().add(LoadRecordsRequested());
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.vehicleRecords),
      ),
      body: BlocConsumer<RecordsBloc, RecordsState>(
        listener: (context, state) {
          // if (state is RecordsInitial) {
          // }
        },
        builder: (context, state) {
          if (state is RecordsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RecordsSuccess) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: context.loc.searchByPlateNumber,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      context.read<RecordsBloc>().add(SearchPlateNumberChanged(value));
                    },
                  ),
                ),
                const Expanded(
                  child: RecordsList(),
                ),
              ],
            );
          } else if (state is RecordsError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return Center(
            child: Text(context.loc.noRecordsAvailable),
          );
        },
      ),
    );
  }
} 