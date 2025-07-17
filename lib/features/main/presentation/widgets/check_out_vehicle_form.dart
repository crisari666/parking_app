import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/core/utils/snackbar_service.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_bloc.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_event.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quantum_parking_flutter/features/main/presentation/widgets/qr_scanner_widget.dart';

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

  void _clearForm() {
    _plateController.clear();
    _paymentValueController.clear();
    setState(() {
      _isEditingPayment = false;
      _originalPaymentValue = null;
    });
  }

  void _startEditingPayment() {
    //print('Starting payment editing. Current value: ${_paymentValueController.text}');
    setState(() {
      _isEditingPayment = true;
      _originalPaymentValue = double.tryParse(_paymentValueController.text);
    });
    //print('Editing state set to: $_isEditingPayment');
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

  String _formatParkingTime(String? parkingTime) {
    if (parkingTime == null) return '';
    
    // Extract minutes from the parking time string (e.g., "45m -> 45)
    final minutesMatch = RegExp(r'(\d+)m').firstMatch(parkingTime);
    if (minutesMatch == null) return parkingTime;
    
    final totalMinutes = int.parse(minutesMatch.group(1)!);
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    
    return '${hours}h, ${minutes.toString().padLeft(2, '0')}m';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {
        // Handle check-out success
        if (state.isCheckout) {
          _clearForm();
          SnackbarService.instance.showSuccessSnackbar(
            context: context,
            message: l10n.success,
          );
          Navigator.of(context).popUntil((route) => route.isFirst); // Close dialog on success
        }

        if(state.parkingTime != null) {
          _plateController.text = state.checkOutPlateNumber.toUpperCase();
        }
        
        // Handle form reset - when parkingTime becomes null after being set
        if (state.parkingTime == null && _plateController.text.isNotEmpty) {
          //_clearForm();
        }
      },
      buildWhen: (previous, current) => 
        previous.vehicleLog != current.vehicleLog || 
        previous.parkingTime != current.parkingTime || 
        (previous.paymentValue != current.paymentValue && !_isEditingPayment),
      builder: (context, state) {
        //print('Building CheckOutVehicleForm. Editing: $_isEditingPayment, PaymentValue: ${state.paymentValue}');
        // Update payment value controller when state changes
        if (state.paymentValue != null && !_isEditingPayment) {
          _paymentValueController.text = state.paymentValue!.toStringAsFixed(2);
        }
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _plateController,
                        keyboardType: TextInputType.visiblePassword,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          labelText: l10n.licensePlate,
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          context.read<MainBloc>().add(CheckOutPlateNumberChanged(value));
                        },
                        readOnly: state.parkingTime != null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (state.parkingTime == null)
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => QRScannerWidget(
                                onQRCodeScanned: (plateNumber) {
                                  context.read<MainBloc>().add(QRCodeScanned(plateNumber));
                                  _plateController.text = plateNumber;
                                },
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.qr_code_scanner),
                        tooltip: l10n.scanQRCode,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                if (state.parkingTime != null) ...[
                  Text('${l10n.parkingTime}: ${_formatParkingTime(state.parkingTime)}'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child:
                         TextField(
                          controller: _paymentValueController,
                          decoration: InputDecoration(
                            labelText: l10n.paymentValue,
                            border: const OutlineInputBorder(),
                            prefixText: '\$',
                            suffixIcon: _isEditingPayment 
                              ? const Icon(Icons.edit, color: Colors.blue)
                              : null,
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          readOnly: !_isEditingPayment,
                          style: TextStyle(
                            color: _isEditingPayment ? Colors.black : Colors.grey[600],
                          ),
                        )),
                      ),
                      if (!_isEditingPayment)
                        IconButton(
                          onPressed: _startEditingPayment,
                          icon: const Icon(Icons.edit),
                          tooltip: l10n.edit,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
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
                  // Student Rate Checkbox for motorcycles
                  if (state.vehicleLog != null && state.vehicleLog!.vehicleType.toLowerCase().contains('motor'))
                    Row(
                      children: [
                        Checkbox(
                          value: state.isStudentRate,
                          onChanged: (checked) {
                            context.read<MainBloc>().add(StudentRateChanged(checked ?? false));
                            // Calculate new payment value locally without service call
                            if (state.paymentValue != null && state.businessSetup != null) {
                              final isMotorcycle = state.vehicleLog!.vehicleType.toLowerCase().contains('motor');
                              if (isMotorcycle) {
                                final newRate = (checked ?? false) 
                                    ? state.businessSetup!.studentMotorcycleHourCost 
                                    : state.businessSetup!.motorcycleHourCost;
                                
                                // Calculate billable hours from current payment value
                                final currentRate = state.isStudentRate 
                                    ? state.businessSetup!.studentMotorcycleHourCost 
                                    : state.businessSetup!.motorcycleHourCost;
                                final billableHours = state.paymentValue! / currentRate;
                                
                                // Calculate new payment value
                                final newPaymentValue = billableHours * newRate;
                                context.read<MainBloc>().add(CheckOutPaymentValueChanged(newPaymentValue));
                              }
                            }
                          },
                        ),
                        Text(l10n.student),
                      ],
                    ),
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
        );
      },
    );
  }
} 