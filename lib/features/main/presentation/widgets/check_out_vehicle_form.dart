import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_bloc.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_event.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CheckOutVehicleForm extends StatefulWidget {
  const CheckOutVehicleForm({super.key});

  @override
  State<CheckOutVehicleForm> createState() => _CheckOutVehicleFormState();
}

class _CheckOutVehicleFormState extends State<CheckOutVehicleForm> {
  final TextEditingController _plateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

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
                SnackBar(content: Text(l10n.success)),
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
                  Text(
                    l10n.checkOutVehicle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _plateController,
                    decoration: InputDecoration(
                      labelText: l10n.licensePlate,
                      border: const OutlineInputBorder(),
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
                      child: Text(l10n.findVehicle),
                    ),
                  if (state is VehicleFoundSuccess) ...[
                    Row(
                      children: [
                        const Icon(Icons.timer),
                        const SizedBox(width: 8),
                        Text(
                          state.parkingTime,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        const Icon(Icons.monetization_on),
                        const SizedBox(width: 8),
                        Text(
                          '\$${state.paymentValue.toString()}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Flexible(
                      child: DropdownButtonFormField<String>(
                        value: state.paymentMethod,
                        decoration: InputDecoration(
                          labelText: l10n.paymentMethod,
                          border: const OutlineInputBorder(),
                        ),
                        items: [
                          DropdownMenuItem(value: 'cash', child: Text(l10n.cash)),
                          DropdownMenuItem(value: 'transaction', child: Text(l10n.transaction)),
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
                      child: Text(l10n.checkOut),
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