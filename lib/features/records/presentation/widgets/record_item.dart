import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/records_bloc.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/records_event.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/models/vehicle_record.dart';
import 'package:quantum_parking_flutter/l10n/app_localizations_context.dart';

class RecordItem extends StatelessWidget {
  final VehicleRecord record;
  final bool hidePlateNumber;

  const RecordItem({
    super.key,
    required this.record,
    this.hidePlateNumber = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      child: InkWell(
        onTap: () {
          context.read<RecordsBloc>().add(GetVehicleLogsRequested(record.plateNumber));
        },
        child: ListTile(
          title: !hidePlateNumber ? Text(record.plateNumber) : null,
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!hidePlateNumber) Text(
                '${context.loc.plateNumber}: ${record.plateNumber}',
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                '${context.loc.type}: ${record.vehicleType}',
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                '${context.loc.checkIn}: ${DateFormat('MMM dd, yyyy HH:mm').format(record.checkIn)}',
                style: const TextStyle(fontSize: 14),
              ),
              if (record.checkOut != null)
                Text(
                  '${context.loc.checkOut}: ${DateFormat('MMM dd, yyyy HH:mm').format(record.checkOut!)}',
                  style: const TextStyle(fontSize: 14),
                ),
              Text(
                '${context.loc.duration}: ${record.duration}',
                style: const TextStyle(fontSize: 14),
              ),
              if (record.totalCost != null)
                Text(
                  '${context.loc.totalCost}: \$${record.totalCost!.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 14),
                ),
            ],
          ),
        ),
      ),
    );
  }
} 