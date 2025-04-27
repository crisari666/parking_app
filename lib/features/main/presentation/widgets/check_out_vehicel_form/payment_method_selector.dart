import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_bloc.dart';

import '../../bloc/main_event.dart';

class PaymentMethodSelector extends StatelessWidget {
  const PaymentMethodSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Vehicle Type',
        border: OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(
          value: 'car',
          child: Text('Car'),
        ),
        DropdownMenuItem(
          value: 'motorcycle',
          child: Text('Motorcycle'),
        ),
      ],
      onChanged: (value) {
        context.read<MainBloc>().add(VehicleTypeChanged(value!));
      },
    );
  }

}