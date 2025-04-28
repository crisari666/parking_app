import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/models/vehicle_record.dart';

@RoutePage()
class VehicleLogsPage extends StatelessWidget {
  final List<VehicleRecord> records;

  const VehicleLogsPage({
    super.key,
    required this.records,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.vehicleRecords),
      ),
      body: records.isEmpty
          ? Center(
              child: Text(l10n.noRecordsAvailable),
            )
          : ListView.builder(
              itemCount: records.length,
              itemBuilder: (context, index) {
                final record = records[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text('${l10n.plateNumber}: ${record.plateNumber}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${l10n.type}: ${record.vehicleType}'),
                        Text('${l10n.checkIn}: ${record.checkIn}'),
                        if (record.checkOut != null)
                          Text('${l10n.checkOut}: ${record.checkOut}'),
                        Text('${l10n.duration}: ${record.duration}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
} 