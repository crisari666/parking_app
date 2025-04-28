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
    final l10n = AppLocalizations.of(context);
    
    // If there are records, get the first record's plate and type for the header
    final String? headerPlate = records.isNotEmpty ? records.first.plateNumber : null;
    final String? headerType = records.isNotEmpty ? records.first.vehicleType : null;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.vehicleRecords),
            if (headerPlate != null && headerType != null)
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
      body: records.isEmpty
          ? Center(
              child: Text(l10n.noRecordsAvailable),
            )
          : ListView.builder(
              itemCount: records.length,
              itemBuilder: (context, index) {
                final record = records[index];
                // Determine if still parking
                final bool stillParking = record.duration.toLowerCase() == "still parked";
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
                            Text('${l10n.checkIn}: ${record.checkIn}'),
                          ],
                        ),
                        if (record.checkOut != null)
                          Row(
                            children: [
                              const Icon(Icons.logout, size: 18, color: Colors.red),
                              const SizedBox(width: 4),
                              Text('${l10n.checkOut}: ${record.checkOut}'),
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
                              Text('${l10n.paymentMethod}: ${switch (record.paymentMethod!.toLowerCase()) {
                                'cash' => l10n.paymentMethodCash,
                                'card' => l10n.paymentMethodCard,
                                'transfer' => l10n.paymentMethodTransfer,
                                _ => record.paymentMethod!
                              }}'),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
} 