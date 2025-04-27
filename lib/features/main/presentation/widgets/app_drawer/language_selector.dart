import 'package:flutter/material.dart';
import 'package:quantum_parking_flutter/l10n/app_localizations_context.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.loc;
    final currentLocale = Localizations.localeOf(context);
    
    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(l10n.language),
      trailing: DropdownButton<String>(
        value: currentLocale.languageCode,
        items: const [
          DropdownMenuItem(
            value: 'en',
            child: Text('English'),
          ),
          DropdownMenuItem(
            value: 'es',
            child: Text('Español'),
          ),
        ],
        onChanged: (String? newValue) {
          if (newValue != null) {
            // TODO: Implement language change logic
            // This will require setting up a localization bloc or provider
            // to handle language changes
          }
        },
      ),
    );
  }
} 