import 'package:flutter/material.dart';
import 'package:quantum_parking_flutter/l10n/app_localizations.dart';

class EnableSwitchField extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const EnableSwitchField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Row(
      children: [
        const Icon(Icons.toggle_on),
        const SizedBox(width: 8),
        Text(l10n.enable),
        const Spacer(),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
