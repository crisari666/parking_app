import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/models/vehicle_record.dart';

class RecordItem extends StatelessWidget {
  final VehicleRecord record;

  const RecordItem({
    super.key,
    required this.record,
  });

  @override
  Widget build(BuildContext context) {
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
  }
} 