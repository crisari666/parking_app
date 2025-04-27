import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_bloc.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_event.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_state.dart';

class CheckOutVehicleForm extends StatefulWidget {
  const CheckOutVehicleForm({super.key});

  @override
  State<CheckOutVehicleForm> createState() => _CheckOutVehicleFormState();
}

class _CheckOutVehicleFormState extends State<CheckOutVehicleForm> {
  final TextEditingController _plateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        return BlocListener<MainBloc, MainState>(
          listener: (context, state) {
            if (state is MainError && state.isCheckout) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red),
              );
            }
            if (state is CheckOutSuccess) {
              _plateController.clear();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Vehicle checked out successfully')),
              );
              Navigator.of(context).pop(); // Close dialog on success
            }
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Check Out Vehicle',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _plateController,
                    decoration: const InputDecoration(
                      labelText: 'License Plate',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      context.read<MainBloc>().add(CheckOutPlateNumberChanged(value));
                    },
                    readOnly: state is VehicleFoundSuccess,
                  ),
                  const SizedBox(height: 16),
                  if (state is! VehicleFoundSuccess)
                    ElevatedButton(
                      onPressed: () {
                        context.read<MainBloc>().add(FindVehicleInParkingRequested(_plateController.text));
                      },
                      child: const Text('Find Vehicle'),
                    ),
                  if (state is VehicleFoundSuccess) ...[
                    TextField(
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Parking Time',
                        border: OutlineInputBorder(),
                      ),
                      controller: TextEditingController(text: state.parkingTime),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Estimated Payment',
                        border: OutlineInputBorder(),
                        prefixText: '\$',
                      ),
                      controller: TextEditingController(
                        text: state.paymentValue.toStringAsFixed(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Flexible(
                      child: DropdownButtonFormField<String>(
                        value: state.paymentMethod,
                        decoration: const InputDecoration(
                        labelText: 'Payment Method',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'cash', child: Text('Cash')),
                        DropdownMenuItem(value: 'transaction', child: Text('Transaction')),
                      ],
                      onChanged: (value) {
                        context.read<MainBloc>().add(PaymentMethodChanged(value!));
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<MainBloc>().add(CheckOutRequested(
                          plate: _plateController.text,
                          paymentMethod: state.paymentMethod,
                          paymentValue: state.paymentValue,
                        ));
                      },
                      child: const Text('Check Out'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
} 