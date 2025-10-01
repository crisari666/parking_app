import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quantum_parking_flutter/features/auth/presentation/bloc/auth_event.dart';
import 'package:quantum_parking_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:quantum_parking_flutter/l10n/app_localizations_context.dart';

class EmailInput extends StatefulWidget {
  const EmailInput({super.key});

  @override
  State<EmailInput> createState() => _EmailInputState();
}

class _EmailInputState extends State<EmailInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.loc;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // Only update controller if state has email data and it's different from current text
        if (state.email.isNotEmpty && _controller.text != state.email) {
          _controller.text = state.email;
        }
      },
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: l10n.email,
          border: const OutlineInputBorder(),
        ),
        onChanged: (value) {
          context.read<AuthBloc>().add(EmailChanged(value));
        },
      ),
    );
  }
} 