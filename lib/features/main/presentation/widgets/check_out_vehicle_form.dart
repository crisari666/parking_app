import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_bloc.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_event.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quantum_parking_flutter/features/main/presentation/widgets/check_out_vehicel_form/payment_method_selector.dart';

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
            if (state.message != null && state.isCheckout) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message!), backgroundColor: Colors.red),
              );
            }
            if (state.isCheckout) {
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
                    readOnly: state.parkingTime != null,
                  ),
                  const SizedBox(height: 16),
                  if (state.parkingTime != null) ...[
                    Text('${l10n.parkingTime}: ${state.parkingTime}'),
                    Text('${l10n.paymentValue}: \$${state.paymentValue?.toStringAsFixed(2)}'),
                    const SizedBox(height: 16),
                    const PaymentMethodSelector(),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<MainBloc>().add(CheckOutRequested(
                          plate: _plateController.text,
                          paymentMethod: state.paymentMethod ?? 'cash',
                          paymentValue: state.paymentValue,
                        ));
                      },
                      child: Text(l10n.checkOut),
                    ),
                  ] else
                    ElevatedButton(
                      onPressed: () {
                        context.read<MainBloc>().add(FindVehicleInParkingRequested(_plateController.text));
                      },
                      child: Text(l10n.findVehicle),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
} 