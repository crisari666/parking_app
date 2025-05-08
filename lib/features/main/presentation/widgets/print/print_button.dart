import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:permission_handler/permission_handler.dart';

class PrintButton extends StatefulWidget {
  final String text;
  final String qrCodeData;
  final String? printerName;

  const PrintButton({
    super.key,
    required this.text,
    required this.qrCodeData,
    this.printerName,
  });

  @override
  State<PrintButton> createState() => _PrintButtonState();
}

class _PrintButtonState extends State<PrintButton> {
  bool _isConnected = false;
  List<String> _pairedDevices = [];
  String? _selectedPrinter;
  final _logger = Logger();

  @override
  void initState() {
    super.initState();
    _selectedPrinter = widget.printerName;
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    try {
      // Check if permissions are already granted
      bool bluetoothGranted = await Permission.bluetooth.isGranted;
      bool bluetoothConnectGranted = await Permission.bluetoothConnect.isGranted;
      bool bluetoothScanGranted = await Permission.bluetoothScan.isGranted;
      bool locationGranted = await Permission.location.isGranted;

      if (!bluetoothGranted || !bluetoothConnectGranted || !bluetoothScanGranted || !locationGranted) {
        // Request permissions if not granted
        Map<Permission, PermissionStatus> statuses = await [
          Permission.bluetooth,
          Permission.bluetoothConnect,
          Permission.bluetoothScan,
          Permission.location,
        ].request();

        bool allGranted = true;
        statuses.forEach((permission, status) {
          if (!status.isGranted) {
            allGranted = false;
            _logger.e('Permission $permission not granted');
          }
        });

        if (!allGranted) {
          _logger.e('Some permissions were not granted');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please grant all required permissions in settings'),
                duration: Duration(seconds: 5),
              ),
            );
          }
          return;
        }
      }

      // If we get here, all permissions are granted
      await _checkConnection();
      await _getPairedDevices();
    } catch (e) {
      _logger.e('Error checking permissions: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error checking permissions: $e'),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _checkConnection() async {
    try {
      final bool isConnected = await PrintBluetoothThermal.connectionStatus;
      _logger.d('Bluetooth connection status: $isConnected');
      setState(() {
        _isConnected = isConnected;
      });
    } catch (e) {
      _logger.e('Error checking connection: $e');
    }
  }

  Future<void> _getPairedDevices() async {
    try {
      final List pairedDevices = await PrintBluetoothThermal.pairedBluetooths;
      _logger.d('Paired devices: $pairedDevices');
      setState(() {
        _pairedDevices = pairedDevices.cast<String>();
      });
    } catch (e) {
      _logger.e('Error getting paired devices: $e');
    }
  }

  Future<void> _connectToPrinter(String macAddress) async {
    try {
      final bool? result = await PrintBluetoothThermal.connect(macPrinterAddress: macAddress);
      _logger.d('Connection result: $result');
      setState(() {
        _isConnected = result ?? false;
        if (_isConnected) {
          _selectedPrinter = macAddress;
        }
      });
    } catch (e) {
      _logger.e('Error connecting to printer: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error connecting to printer: $e')),
        );
      }
    }
  }

  Future<void> _printTicket() async {
    if (!_isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please connect to a printer first')),
      );
      return;
    }

    try {
      // Print header
      await PrintBluetoothThermal.writeString(
        printText: PrintTextSize(
          size: 2,
          text: 'QUANTUM PARKING\n',
        ),
      );

      // Print main text
      await PrintBluetoothThermal.writeString(
        printText: PrintTextSize(
          size: 1,
          text: '${widget.text}\n',
        ),
      );

      // Print QR code data as text
      await PrintBluetoothThermal.writeString(
        printText: PrintTextSize(
          size: 1,
          text: 'QR Code Data:\n${widget.qrCodeData}\n',
        ),
      );

      // Print footer
      await PrintBluetoothThermal.writeString(
        printText: PrintTextSize(
          size: 1,
          text: '\nThank you!\n',
        ),
      );

      // Cut paper
      await PrintBluetoothThermal.writeString(
        printText: PrintTextSize(
          size: 1,
          text: '\n\n\n',
        ),
      );
    } catch (e) {
      _logger.e('Error printing ticket: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error printing: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_pairedDevices.isNotEmpty) ...[
          DropdownButton<String>(
            value: _selectedPrinter,
            hint: const Text('Select Printer'),
            items: _pairedDevices.map((String device) {
              return DropdownMenuItem<String>(
                value: device,
                child: Text(device),
              );
            }).toList(),
            onChanged: (String? value) {
              if (value != null) {
                _connectToPrinter(value);
              }
            },
          ),
          const SizedBox(height: 8),
        ],
        ElevatedButton.icon(
          onPressed: _isConnected ? _printTicket : null,
          icon: Icon(_isConnected ? Icons.print : Icons.print_disabled),
          label: Text(_isConnected ? 'Print Ticket' : 'Connect Printer'),
        ),
      ],
    );
  }
}
