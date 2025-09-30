import 'package:flutter/material.dart';
import 'package:quantum_parking_flutter/l10n/app_localizations.dart';
import 'package:quantum_parking_flutter/features/records/data/models/daily_closure_model.dart';
import 'package:quantum_parking_flutter/features/records/data/models/financial_resume_model.dart';
import 'package:intl/intl.dart';

class DailySummaryCard extends StatelessWidget {
  final DailyClosureModel? closure;
  final FinancialResumeModel? financialResume;
  final AppLocalizations l10n;

  const DailySummaryCard({
    super.key,
    this.closure,
    this.financialResume,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.blueGrey[50],
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.summarize, color: Colors.blueGrey[700], size: 28),
                const SizedBox(width: 10),
                Text(
                  l10n.dailySummary,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.blueGrey[400]),
                const SizedBox(width: 8),
                Text(
                  '${l10n.date}: ',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  DateFormat('MMM dd, yyyy').format(financialResume?.date ?? closure?.date ?? DateTime.now()),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const Divider(height: 24, thickness: 1.2),
            Row(
              children: [
                Icon(Icons.directions_car_filled, color: Colors.green[700]),
                const SizedBox(width: 8),
                Text(
                  '${l10n.totalCars}: ',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  '${financialResume?.vehicleBreakdown.car.count ?? closure?.vehiclesByType['car'] ?? 0}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.motorcycle, color: Colors.deepPurple[700]),
                const SizedBox(width: 8),
                Text(
                  '${l10n.totalMotorcycles}: ',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  '${financialResume?.vehicleBreakdown.motorcycle.count ?? closure?.vehiclesByType['motorcycle'] ?? 0}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const Divider(height: 24, thickness: 1.2),
            Row(
              children: [
                Icon(Icons.format_list_numbered, color: Colors.orange[700]),
                const SizedBox(width: 8),
                Text(
                  '${l10n.totalVehicles}: ',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  '${financialResume?.statistics.totalVehiclesProcessed ?? closure?.totalVehicles ?? 0}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 