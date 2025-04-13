import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_bloc.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_event.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_state.dart';

class CheckOutVehicleForm extends StatelessWidget {
  final TextEditingController _textEditingController = TextEditingController();

  CheckOutVehicleForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MainBloc, MainState>(
      listener: (context, state) {
        if (state is MainError && state.isCheckout) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
        if (state is CheckOutSuccess) {
          _textEditingController.clear();
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
                controller: _textEditingController,
                decoration: const InputDecoration(
                  labelText: 'License Plate',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  context.read<MainBloc>().add(PlateNumberChanged(value));
                },
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Discount (optional)',
                  border: OutlineInputBorder(),
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  context.read<MainBloc>().add(DiscountChanged(value));
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<MainBloc>().add(CheckOutRequested());
                },
                child: const Text('Check Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 