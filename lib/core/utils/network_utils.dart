import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:quantum_parking_flutter/core/config/env.dart';

class NetworkUtils {
  static Future<String> getBaseUrl(String originalUrl) async {
    if (kIsWeb) return originalUrl;

    if (Platform.isAndroid) {
      if (originalUrl.contains('localhost')) {
        // Check if running on emulator
        try {
          final info = NetworkInfo();
          final wifiIP = await info.getWifiIP();
          
          if (wifiIP == null) {
            // If no WiFi IP, likely running on emulator
            return originalUrl.replaceAll('localhost', '10.0.2.2');
          }
          
          // Running on physical device, use the computer's IP
          final computerIP = await _getComputerIP();
        return originalUrl.replaceAll('localhost', computerIP);
        } catch (e) {
          // Fallback to emulator address
          return originalUrl.replaceAll('localhost', '10.0.2.2');
        }
      }
    }
    
    return originalUrl;
  }

  static Future<String> _getComputerIP() async {
    try {
      // return '192.168.1.27';
      final info = NetworkInfo();
      final wifiIP = await info.getWifiIP();
      if(Env.isLocalhost) {
        return '10.0.2.2';
      } else if (wifiIP != null) {
        // Get the network prefix (e.g., 192.168.1)
        final parts = wifiIP.split('.');
        if (parts.length == 4) {
          // Return the first three octets
          return '${parts[0]}.${parts[1]}.${parts[2]}';
        }
      }
      throw Exception('Could not determine network prefix');
    } catch (e) {
      throw Exception('Failed to get computer IP: $e');
    }
  }
} 