import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/records_bloc.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/records_event.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/records_state.dart';
import 'package:quantum_parking_flutter/injection/injection.dart';

@RoutePage()
class VehicleLogsPage extends StatelessWidget {
  final String plateNumber;
  final String vehicleType;

  const VehicleLogsPage({
    super.key,
    required this.plateNumber,
    required this.vehicleType,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    // If there are records, get the first record's plate and type for the header
    final String headerPlate = plateNumber;
    final String headerType = vehicleType;
    final RecordsBloc recordsBloc = getIt.get<RecordsBloc>();
    return BlocProvider.value(
      value: recordsBloc..add(GetVehicleLogsRequested(plateNumber)),
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.vehicleRecords),
                Row(
                  children: [
                    const Icon(Icons.directions_car, size: 18),
                    const SizedBox(width: 4),
                    Text(headerPlate, style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 8),
                    const Icon(Icons.category, size: 18),
                    const SizedBox(width: 4),
                    Text(headerType, style: const TextStyle(fontSize: 14)),
                  ],
                ),
            ],
          ),
        ),
        body: BlocBuilder<RecordsBloc, RecordsState>(
        builder: (context, state) {
          return state.vehicleLogs?.isEmpty ?? true ? Center(
                  child: Text(l10n.noRecordsAvailable),
                )
              : ListView.builder(
                itemCount: state.vehicleLogs?.length ?? 0,
                itemBuilder: (context, index) {
                  final record = state.vehicleLogs![index];
                  // Determine if still parking
                  final bool stillParking = record.exitTime == null;
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.login, size: 18, color: Colors.green),
                              const SizedBox(width: 4),
                              Text('${l10n.checkIn}: ${record.entryTime}'),
                            ],
                          ),
                          if (record.exitTime != null)
                            Row(
                              children: [
                                const Icon(Icons.logout, size: 18, color: Colors.red),
                                const SizedBox(width: 4),
                                Text('${l10n.checkOut}: ${record.exitTime}'),
                              ],
                            ),
                          Row(
                            children: [
                              const Icon(Icons.timer, size: 18, color: Colors.blue),
                              const SizedBox(width: 4),
                              Text(
                                '${l10n.duration}: ${stillParking ? l10n.stillParking : record.duration}',
                              ),
                            ],
                          ),
                          if (record.paymentMethod != null)
                            Row(
                              children: [
                                const Icon(Icons.payment, size: 18, color: Colors.purple),
                                const SizedBox(width: 4),
                                Text('${l10n.paymentMethod}: ${record.paymentMethod?.name}'),
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
        }
      )
    ));
  }
} 