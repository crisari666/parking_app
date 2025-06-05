import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/records_bloc.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/records_event.dart';
import 'package:quantum_parking_flutter/features/main/data/models/active_vehicle_log_model.dart';
import 'package:quantum_parking_flutter/l10n/app_localizations_context.dart';

class RecordItem extends StatelessWidget {
  final ActiveVehicleLogModel record;
  final bool hidePlateNumber;

  const RecordItem({
    super.key,
    required this.record,
    this.hidePlateNumber = false,
  });

  String _getLocalizedVehicleType(BuildContext context, String type) {
    final l10n = AppLocalizations.of(context);
    switch (type.toLowerCase()) {
      case 'car':
        return l10n.vehicleTypeCar;
      case 'motorcycle':
        return l10n.vehicleTypeMotorcycle;
      case 'truck':
        return l10n.vehicleTypeTruck;
      case 'van':
        return l10n.vehicleTypeVan;
      default:
        return type;
    }
  }

  String _formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    
    if (hours > 0) {
      return '$hours hour${hours > 1 ? 's' : ''} $remainingMinutes minute${remainingMinutes > 1 ? 's' : ''}';
    } else {
      return '$remainingMinutes minute${remainingMinutes > 1 ? 's' : ''}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 8.0,
      ),
      child: InkWell(
        onTap: () {
          context.read<RecordsBloc>().add(GetVehicleLogsRequested(record.vehicleId.plateNumber));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Plate number and vehicle type in the same row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!hidePlateNumber) ...[
                    Row(
                      children: [
                        const Icon(Icons.directions_car, size: 20, color: Colors.blueGrey),
                        const SizedBox(width: 6),
                        Text(
                          record.vehicleId.plateNumber,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(width: 16),
                  Row(
                    children: [
                      const Icon(Icons.category, size: 20, color: Colors.teal),
                      const SizedBox(width: 6),
                      Text(
                        _getLocalizedVehicleType(context, record.vehicleId.vehicleType),
                        style: const TextStyle(fontSize: 15, color: Colors.black87),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Check-in and Check-out in a row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.login, size: 18, color: Colors.green),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('MMM dd, yyyy HH:mm').format(record.entryTime),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  if (record.exitTime != null) ...[
                    Row(
                      children: [
                        const Icon(Icons.logout, size: 18, color: Colors.red),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('MMM dd, yyyy HH:mm').format(record.exitTime!),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              // Duration with icon
              Row(
                children: [
                  const Icon(Icons.timer, size: 18, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text(
                    record.exitTime == null 
                        ? context.loc.stillParking
                        : _formatDuration(record.duration),
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              // Total cost with icon (if available)
              if (record.cost > 0) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.attach_money, size: 18, color: Colors.green),
                    const SizedBox(width: 4),
                    Text(
                      record.cost.toString(),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
} 