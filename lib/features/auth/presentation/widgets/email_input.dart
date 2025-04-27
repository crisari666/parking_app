import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quantum_parking_flutter/l10n/app_localizations_context.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.loc;
    return TextField(
      decoration: InputDecoration(
        labelText: l10n.email,
        border: const OutlineInputBorder(),
      ),
      onChanged: (value) {
        context.read<AuthBloc>().add(EmailChanged(value));
      },
    );
  }
} 