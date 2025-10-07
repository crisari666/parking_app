import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:quantum_parking_flutter/l10n/app_localizations.dart';

@RoutePage()
class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = packageInfo;
    });
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.about),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            const SizedBox(height: 40),
            
            // App Icon/Logo placeholder
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.local_parking,
                size: 60,
                color: Theme.of(context).primaryColor,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // App Name
            Text(
              l10n.appTitle,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // App Description
            Text(
              l10n.appDescription,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 40),
            
            // Version Information Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Text(
                      l10n.versionInformation,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_packageInfo != null) ...[
                      _buildInfoRow(l10n.appVersion, _packageInfo!.version),
                      const SizedBox(height: 8),
                      _buildInfoRow(l10n.buildNumber, _packageInfo!.buildNumber),
                      const SizedBox(height: 8),
                      _buildInfoRow(l10n.packageName, _packageInfo!.packageName),
                    ] else ...[
                      const CircularProgressIndicator(),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Developer Information
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Text(
                      l10n.developerInformation,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Quantum Devs Link
                    ListTile(
                      leading: const Icon(Icons.business),
                      title: Text(l10n.developedBy),
                      subtitle: const Text('Quantum Devs'),
                      trailing: const Icon(Icons.open_in_new),
                      onTap: () => _launchUrl('https://quantum-devs.xyz/'),
                    ),
                    
                    const Divider(),
                    
                    // LinkedIn Link
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(l10n.developer),
                      subtitle: const Text('Cristhian Gracia'),
                      trailing: const Icon(Icons.open_in_new),
                      onTap: () => _launchUrl('https://www.linkedin.com/in/cristhian-gracia-dev/'),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Copyright
            Text(
              l10n.copyright,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
