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
    final theme = Theme.of(context);
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: theme.colorScheme.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  Icons.summarize, 
                  color: theme.colorScheme.onSurfaceVariant, 
                  size: 28
                ),
                const SizedBox(width: 10),
                Text(
                  l10n.dailySummary,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Icon(
                  Icons.calendar_today, 
                  color: theme.colorScheme.onSurfaceVariant
                ),
                const SizedBox(width: 8),
                Text(
                  '${l10n.date}: ',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  DateFormat('MMM dd, yyyy').format(financialResume?.date ?? closure?.date ?? DateTime.now()),
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const Divider(height: 24, thickness: 1.2),
            Row(
              children: [
                Icon(
                  Icons.directions_car_filled, 
                  color: theme.colorScheme.primary
                ),
                const SizedBox(width: 8),
                Text(
                  '${l10n.totalCars}: ',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  '${financialResume?.vehicleBreakdown.car.count ?? closure?.vehiclesByType['car'] ?? 0}',
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.motorcycle, 
                  color: theme.colorScheme.secondary
                ),
                const SizedBox(width: 8),
                Text(
                  '${l10n.totalMotorcycles}: ',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  '${financialResume?.vehicleBreakdown.motorcycle.count ?? closure?.vehiclesByType['motorcycle'] ?? 0}',
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const Divider(height: 24, thickness: 1.2),
            Row(
              children: [
                Icon(
                  Icons.format_list_numbered, 
                  color: theme.colorScheme.tertiary
                ),
                const SizedBox(width: 8),
                Text(
                  '${l10n.totalVehicles}: ',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  '${financialResume?.statistics.totalVehiclesProcessed ?? closure?.totalVehicles ?? 0}',
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 