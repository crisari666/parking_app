import 'package:flutter/material.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/models/vehicle_record.dart';
import 'package:quantum_parking_flutter/features/records/presentation/widgets/record_item.dart';

class VehicleLogsDialog extends StatelessWidget {
  final List<VehicleRecord> logs;
  final String plateNumber;

  const VehicleLogsDialog({
    super.key,
    required this.logs,
    required this.plateNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Past Logs for $plateNumber',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 400,
              child: ListView.builder(
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final record = logs[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: RecordItem(record: record, hidePlateNumber: true),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
} 