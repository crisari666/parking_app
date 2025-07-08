import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:quantum_parking_flutter/l10n/app_localizations_context.dart';

class UpdateDialog extends StatelessWidget {
  final String currentVersion;
  final String minRequiredVersion;
  final String storeUrl;

  const UpdateDialog({
    super.key,
    required this.currentVersion,
    required this.minRequiredVersion,
    required this.storeUrl,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.loc;
    
    return WillPopScope(
      onWillPop: () async => false, // Prevent back button from closing dialog
      child: AlertDialog(
        title: Text(l10n.updateRequired),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.updateRequiredMessage),
            const SizedBox(height: 16),
            Text('${l10n.currentVersion}: $currentVersion'),
            Text('${l10n.minimumVersion}: $minRequiredVersion'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final uri = Uri.parse(storeUrl);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
            child: Text(l10n.updateNow),
          ),
        ],
      ),
    );
  }
} 