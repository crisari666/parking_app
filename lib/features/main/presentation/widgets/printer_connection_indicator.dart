import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_bloc.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_event.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_state.dart';
import 'package:quantum_parking_flutter/l10n/app_localizations_context.dart';

class PrinterConnectionIndicator extends StatelessWidget {
  const PrinterConnectionIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: state.isPrinterConnected 
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: state.isPrinterConnected ? Colors.green : Colors.red,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    state.isPrinterConnected 
                        ? Icons.print 
                        : Icons.print_disabled,
                    color: state.isPrinterConnected ? Colors.green : Colors.red,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    state.isPrinterConnected 
                        ? context.loc.printerConnected
                        : context.loc.printerDisconnected,
                    style: TextStyle(
                      color: state.isPrinterConnected ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                  if (state.isPrinterConnected && state.printerName != null) ...[
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        '(${state.printerName!.split(' - ').first})',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (state.isPrinterConnected) ...[
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  context.read<MainBloc>().add(PerformPrinterHardwareTest());
                },
                icon: const Icon(Icons.build, size: 16),
                tooltip: 'Test Printer Hardware',
                style: IconButton.styleFrom(
                  backgroundColor: Colors.blue.withValues(alpha: 0.1),
                  foregroundColor: Colors.blue,
                  padding: const EdgeInsets.all(8),
                  minimumSize: const Size(32, 32),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
} 