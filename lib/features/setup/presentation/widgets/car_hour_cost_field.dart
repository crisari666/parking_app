import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/bloc/setup_bloc.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/bloc/setup_event.dart';

class CarHourCostField extends StatelessWidget {
  final String initialValue;
  
  const CarHourCostField({
    super.key,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: initialValue),
      decoration: const InputDecoration(
        labelText: 'Car Hour Cost',
        border: OutlineInputBorder(),
        prefixText: '\$',
      ),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        context.read<SetupBloc>().add(CarHourCostChanged(value));
      },
    );
  }
} 