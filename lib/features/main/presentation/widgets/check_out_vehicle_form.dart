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
  final TextEditingController _paymentValueController = TextEditingController();
  bool _isEditingPayment = false;
  double? _originalPaymentValue;

  @override
  void dispose() {
    _plateController.dispose();
    _paymentValueController.dispose();
    super.dispose();
  }

  void _startEditingPayment() {
    setState(() {
      _isEditingPayment = true;
      _originalPaymentValue = double.tryParse(_paymentValueController.text);
    });
  }

  void _cancelEditingPayment() {
    setState(() {
      _isEditingPayment = false;
      _paymentValueController.text = _originalPaymentValue?.toStringAsFixed(2) ?? '';
    });
  }

  void _savePaymentValue() {
    final newValue = double.tryParse(_paymentValueController.text);
    if (newValue != null) {
      context.read<MainBloc>().add(CheckOutPaymentValueChanged(newValue));
    }
    setState(() {
      _isEditingPayment = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        // Update payment value controller when state changes
        if (state.paymentValue != null && !_isEditingPayment) {
          _paymentValueController.text = state.paymentValue!.toStringAsFixed(2);
        }

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
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _paymentValueController,
                            decoration: InputDecoration(
                              labelText: l10n.paymentValue,
                              border: const OutlineInputBorder(),
                              prefixText: '\$',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            readOnly: !_isEditingPayment,
                          ),
                        ),
                        if (!_isEditingPayment)
                          ElevatedButton(
                            onPressed: _startEditingPayment,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(color: Colors.blue),
                              ),
                            ),
                            child: const Icon(Icons.edit),
                          )
                        else
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton.outlined(
                                icon: const Icon(Icons.check),
                                onPressed: _savePaymentValue,
                                style: IconButton.styleFrom(
                                  foregroundColor: Colors.green,
                                ),
                              ),
                              IconButton.outlined(
                                icon: const Icon(Icons.close),
                                onPressed: _cancelEditingPayment,
                                style: IconButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
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