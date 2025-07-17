import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/bloc/setup_bloc.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/bloc/setup_event.dart';

class AddressField extends StatelessWidget {
  final String initialValue;
  final String label;
  final bool enabled;

  const AddressField({
    super.key,
    required this.initialValue,
    required this.label,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: 3,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      onChanged: (value) {
        context.read<SetupBloc>().add(SetupAddressChanged(address: value));
      },
    );
  }
} 