import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/bloc/setup_bloc.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/bloc/setup_event.dart';

class CarHourCostField extends StatelessWidget {
  final String initialValue;
  final String label;

  const CarHourCostField({
    super.key,
    required this.initialValue,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      onChanged: (value) {
        context.read<SetupBloc>().add(SetupCarHourCostChanged(value));
      },
    );
  }
} 