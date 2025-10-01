import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/bloc/setup_bloc.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/bloc/setup_event.dart';

class ScheduleField extends StatelessWidget {
  final String initialValue;
  final String label;
  final bool enabled;

  const ScheduleField({
    super.key,
    required this.initialValue,
    required this.label,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[50],
        hintText: 'Mon-Fri 8:00-18:00',
      ),
      onChanged: (value) {
        context.read<SetupBloc>().add(SetupScheduleChanged(schedule: value));
      },
    );
  }
} 