import 'package:flutter/material.dart';
import 'package:quantum_parking_flutter/features/config/domain/services/config_service.dart';
import 'package:quantum_parking_flutter/injection/injection.dart';
import 'package:quantum_parking_flutter/l10n/app_localizations_context.dart';

class ConfigInfoWidget extends StatefulWidget {
  const ConfigInfoWidget({super.key});

  @override
  State<ConfigInfoWidget> createState() => _ConfigInfoWidgetState();
}

class _ConfigInfoWidgetState extends State<ConfigInfoWidget> {
  final ConfigService _configService = getIt<ConfigService>();
  String? _appName;
  String? _minBuildNumber;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    try {
      final appName = await _configService.getAppName();
      final minBuildNumber = await _configService.getMinBuildNumber();
      
      setState(() {
        _appName = appName;
        _minBuildNumber = minBuildNumber?.toString();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.loc;
    
    if (_isLoading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.appConfiguration,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (_appName != null) ...[
              Text('${l10n.appName}: $_appName'),
              const SizedBox(height: 4),
            ],
            if (_minBuildNumber != null) ...[
              Text('${l10n.minimumVersion}: $_minBuildNumber'),
              const SizedBox(height: 4),
            ],
            TextButton(
              onPressed: _loadConfig,
              child: Text(l10n.refresh),
            ),
          ],
        ),
      ),
    );
  }
} 