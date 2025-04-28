import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/records_bloc.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/records_event.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/models/vehicle_record.dart';

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
                      record.plateNumber,
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
                    record.vehicleType,
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
                    DateFormat('MMM dd, yyyy HH:mm').format(record.checkIn),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  if (record.checkOut != null) ...[
                    Row(
                      children: [
                        const Icon(Icons.logout, size: 18, color: Colors.red),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('MMM dd, yyyy HH:mm').format(record.checkOut!),
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
                    record.duration,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              // Total cost with icon (if available)
              if (record.totalCost != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.attach_money, size: 18, color: Colors.green),
                    const SizedBox(width: 4),
                    Text(
                      record.totalCost!.toStringAsFixed(2),
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