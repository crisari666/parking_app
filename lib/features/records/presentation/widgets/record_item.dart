import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

  String _getLocalizedPaymentMethod(BuildContext context, String method) {
    final l10n = AppLocalizations.of(context);
    switch (method.toLowerCase()) {
      case 'cash':
        return l10n.paymentMethodCash;
      case 'card':
        return l10n.paymentMethodCard;
      case 'transfer':
        return l10n.paymentMethodTransfer;
      default:
        return method;
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
                        _getLocalizedVehicleType(context, record.vehicleType),
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
                    record.checkOut == null 
                        ? context.loc.stillParking
                        : record.duration,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              // Total cost and payment method with icons (if available)
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
                    if (record.paymentMethod != null) ...[
                      const SizedBox(width: 16),
                      const Icon(Icons.payment, size: 18, color: Colors.blue),
                      const SizedBox(width: 4),
                      Text(
                        _getLocalizedPaymentMethod(context, record.paymentMethod!),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
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