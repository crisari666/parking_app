import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/printer_setup_bloc.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/printer_setup_event.dart';

class PrinterSetupErrorWidget extends StatelessWidget {
  final String message;

  const PrinterSetupErrorWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<PrinterSetupBloc>().add(PrinterSetupStarted());
            },
            child: Text(l10n.retry),
          ),
        ],
      ),
    );
  }
}