import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/bloc/setup_bloc.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/bloc/setup_event.dart';

class MotorcycleNightCostField extends StatelessWidget {
  final String initialValue;
  final String label;
  
  const MotorcycleNightCostField({
    super.key,
    required this.initialValue,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {    
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      onChanged: (value) {
        context.read<SetupBloc>().add(SetupMotorcycleNightCostChanged(cost: value));
      },
    );
  }
} 