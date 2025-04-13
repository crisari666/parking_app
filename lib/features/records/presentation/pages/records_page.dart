import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/records_bloc.dart';
import 'package:intl/intl.dart';
import 'package:auto_route/auto_route.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/records_event.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/records_state.dart';

@RoutePage()
class RecordsPage extends StatelessWidget {
  const RecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<RecordsBloc>().add(LoadRecordsRequested());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Records'),
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
                    decoration: const InputDecoration(
                      labelText: 'Search by Plate Number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      context.read<RecordsBloc>().add(SearchPlateNumberChanged(value));
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.records.length,
                    itemBuilder: (context, index) {
                      final record = state.records[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: ListTile(
                          title: Text(record.plateNumber),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Type: ${record.vehicleType}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                'Check In: ${DateFormat('MMM dd, yyyy HH:mm').format(record.checkIn)}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              if (record.checkOut != null)
                                Text(
                                  'Check Out: ${DateFormat('MMM dd, yyyy HH:mm').format(record.checkOut!)}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              Text(
                                'Duration: ${record.duration}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              if (record.totalCost != null)
                                Text(
                                  'Total Cost: \$${record.totalCost!.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
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
          return const Center(
            child: Text('No records available'),
          );
        },
      ),
    );
  }
} 