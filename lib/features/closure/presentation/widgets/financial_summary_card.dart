import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:quantum_parking_flutter/features/records/data/models/daily_closure_model.dart';
import 'package:quantum_parking_flutter/features/records/data/models/financial_resume_model.dart';

class FinancialSummaryCard extends StatelessWidget {
  final DailyClosureModel? closure;
  final FinancialResumeModel? financialResume;
  final AppLocalizations l10n;

  const FinancialSummaryCard({
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
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {}, // Add any onTap functionality if needed
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.analytics_outlined,
                    color: theme.primaryColor,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.financialSummary,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildFinancialRow(
                icon: Icons.payments_outlined,
                label: l10n.totalSales,
                value: financialResume?.summary.totalPaidByVehicles ?? closure?.totalIncome ?? 0.0,
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              _buildFinancialRow(
                icon: Icons.card_membership,
                label: l10n.totalMemberships,
                value: financialResume?.summary.totalReceivedByMemberships ?? 0.0,
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              _buildFinancialRow(
                icon: Icons.account_balance_wallet_outlined,
                label: l10n.netSales,
                value: financialResume?.summary.totalRevenue ?? closure?.totalIncome ?? 0.0,
                color: theme.primaryColor,
                isBold: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFinancialRow({
    required IconData icon,
    required String label,
    required double value,
    required Color color,
    bool isBold = false,
  }) {
    final formatter = NumberFormat('#,##0', 'en_US');
    final formattedValue = formatter.format(value.round());
    
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
        ),
        Text(
          '\$$formattedValue',
          style: TextStyle(
            fontSize: isBold ? 18 : 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: color,
          ),
        ),
      ],
    );
  }
} 