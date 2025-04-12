import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/bloc/setup_bloc.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/bloc/setup_event.dart';

class BusinessBrandField extends StatelessWidget {
  final String initialValue;
  const BusinessBrandField({super.key, required this.initialValue});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: initialValue),
      decoration: const InputDecoration(
        labelText: 'Business Brand',
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        context.read<SetupBloc>().add(BusinessBrandChanged(value));
      },
    );
  }
} 