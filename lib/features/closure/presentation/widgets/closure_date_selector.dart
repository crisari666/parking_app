import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quantum_parking_flutter/features/closure/presentation/bloc/closure_bloc.dart';
import 'package:quantum_parking_flutter/features/closure/presentation/bloc/closure_event.dart';

class ClosureDateSelector extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;

  const ClosureDateSelector({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.selectDate,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton.icon(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null && picked != selectedDate) {
                  onDateChanged(picked);
                  // Dispatch event to get closure data for the selected date
                  context.read<ClosureBloc>().add(GetClosureDataByDate(picked));
                }
              },
              icon: const Icon(Icons.calendar_today),
              label: Text(
                '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 