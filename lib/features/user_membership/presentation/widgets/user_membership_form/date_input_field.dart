import 'package:flutter/material.dart';
import 'package:quantum_parking_flutter/l10n/app_localizations.dart';

class DateInputField extends StatelessWidget {
  final String labelText;
  final DateTime? selectedDate;
  final VoidCallback onTap;
  final bool isStartDate;

  const DateInputField({
    super.key,
    required this.labelText,
    required this.selectedDate,
    required this.onTap,
    this.isStartDate = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
          selectedDate != null 
              ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
              : l10n.selectDate,
          style: selectedDate != null 
              ? null 
              : Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
        ),
      ),
    );
  }
}
