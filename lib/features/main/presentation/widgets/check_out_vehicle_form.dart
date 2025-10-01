import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/core/utils/snackbar_service.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_bloc.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_event.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_state.dart';
import 'package:quantum_parking_flutter/l10n/app_localizations.dart';
import 'package:quantum_parking_flutter/features/main/presentation/widgets/qr_scanner_widget.dart';
import 'package:quantum_parking_flutter/core/utils/parking_rate_calculator.dart';

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
  bool _shouldPrintReceipt = false;

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
                  const SizedBox(height: 8),
                  // Show membership message if vehicle has active membership
                  if (state.vehicleLog?.hasMembership == true)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        border: Border.all(color: Colors.green.shade200),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green.shade600, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'El vehículo cuenta con una mensualidad activa - No se aplicará cobro',
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                          readOnly: !_isEditingPayment || state.vehicleLog?.hasMembership == true,
                          style: TextStyle(
                            color: _isEditingPayment ? Colors.black : Colors.grey[600],
                          ),
                        )),
                      ),
                      if (!_isEditingPayment && state.vehicleLog?.hasMembership != true)
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
                  // Student Rate Checkbox for motorcycles (only show if no membership)
                  if (state.vehicleLog != null && 
                      state.vehicleLog!.vehicleType.toLowerCase().contains('motor') &&
                      state.vehicleLog!.hasMembership != true)
                    Row(
                      children: [
                        Checkbox(
                          value: state.isStudentRate,
                          onChanged: (checked) {
                            context.read<MainBloc>().add(StudentRateChanged(checked ?? false));
                            // Calculate new payment value locally using ParkingRateCalculator
                            if (state.paymentValue != null && state.businessSetup != null) {
                              final isMotorcycle = state.vehicleLog!.vehicleType.toLowerCase().contains('motor');
                              if (isMotorcycle) {
                                final currentRate = state.isStudentRate
                                    ? state.businessSetup!.studentMotorcycleHourCost
                                    : state.businessSetup!.motorcycleHourCost;
                                final newRate = (checked ?? false)
                                    ? state.businessSetup!.studentMotorcycleHourCost
                                    : state.businessSetup!.motorcycleHourCost;
                                final newPaymentValue = ParkingRateCalculator.recalculatePaymentValue(
                                  currentPaymentValue: state.paymentValue!,
                                  currentRatePerHour: currentRate,
                                  newRatePerHour: newRate,
                                );
                                context.read<MainBloc>().add(CheckOutPaymentValueChanged(newPaymentValue));
                              }
                            }
                          },
                        ),
                        Text(l10n.student),
                      ],
                    ),
                 // Print receipt checkbox
                 Row(
                   children: [
                     Checkbox(
                       value: _shouldPrintReceipt,
                       onChanged: (checked) {
                         setState(() {
                           _shouldPrintReceipt = checked ?? false;
                         });
                       },
                     ),
                     Text(l10n.printCheckOutReceipt),
                   ],
                 ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                     context.read<MainBloc>().add(CheckOutRequested(
                       plate: _plateController.text,
                       paymentMethod: state.paymentMethod ?? 'cash',
                       paymentValue: state.paymentValue,
                       shouldPrint: _shouldPrintReceipt,
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