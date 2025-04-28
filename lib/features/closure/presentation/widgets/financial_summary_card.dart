import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quantum_parking_flutter/features/records/data/models/daily_closure_model.dart';

class FinancialSummaryCard extends StatelessWidget {
  final DailyClosureModel closure;
  final AppLocalizations l10n;

  const FinancialSummaryCard({
    super.key,
    required this.closure,
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
                value: closure.totalIncome,
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              _buildFinancialRow(
                icon: Icons.discount_outlined,
                label: l10n.totalDiscounts,
                value: 0.00,
                color: Colors.orange,
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              _buildFinancialRow(
                icon: Icons.account_balance_wallet_outlined,
                label: l10n.netSales,
                value: closure.totalIncome,
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
          '\$${value.toStringAsFixed(2)}',
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