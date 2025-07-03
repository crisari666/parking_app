import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_bloc.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_event.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_state.dart';

class PrintQRExample extends StatefulWidget {
  const PrintQRExample({super.key});

  @override
  State<PrintQRExample> createState() => _PrintQRExampleState();
}

class _PrintQRExampleState extends State<PrintQRExample> {
  final TextEditingController _plateController = TextEditingController();

  @override
  void dispose() {
    _plateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Printing Example'),
      ),
      body: BlocListener<MainBloc, MainState>(
        listener: (context, state) {
          if (state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message!),
                backgroundColor: state.message!.contains('printed successfully') 
                    ? Colors.green 
                    : Colors.red,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'QR Code Printing',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'This example demonstrates how to print QR codes for vehicle check-in receipts using PDF printing. '
                        'The QR code contains the vehicle plate number and can be scanned for verification.',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _plateController,
                decoration: const InputDecoration(
                  labelText: 'Vehicle Plate Number',
                  border: OutlineInputBorder(),
                  hintText: 'Enter plate number (e.g., ABC123)',
                ),
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _plateController.text.isEmpty
                    ? null
                    : () {
                        context.read<MainBloc>().add(
                              PrintQRCodeRequested(_plateController.text),
                            );
                      },
                icon: const Icon(Icons.print),
                label: const Text('Print QR Code'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 16),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Features:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('• Automatic QR code printing on vehicle check-in'),
                      Text('• Manual QR code printing with plate number'),
                      Text('• Business name and branding on receipt'),
                      Text('• Date and time stamp'),
                      Text('• PDF-based printing for better quality'),
                      Text('• Optimized business setup access'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 