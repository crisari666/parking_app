import 'package:hive/hive.dart';
import '../models/vehicle_model.dart';

class LocalStorageService {
  static const String _vehicleBoxName = 'vehicles';
  static const String _parkingLogBoxName = 'parking_logs';
  
  late Box<VehicleModel> _vehicleBox;
  late Box<Map<String, dynamic>> _parkingLogBox;

  Future<void> init() async {
    _vehicleBox = await Hive.openBox<VehicleModel>(_vehicleBoxName);
    _parkingLogBox = await Hive.openBox<Map<String, dynamic>>(_parkingLogBoxName);
  }

  Future<bool> saveVehicle(VehicleModel vehicle) async {
    try {
      // Check if vehicle is already checked in and not checked out
      final existingVehicle = _vehicleBox.get(vehicle.plateNumber);
      if (existingVehicle != null && existingVehicle.checkOut == null) {
        return false; // Vehicle already checked in
      }

      await _vehicleBox.put(vehicle.plateNumber, vehicle);
      
      // Save parking log
      final log = {
        'plateNumber': vehicle.plateNumber,
        'checkIn': vehicle.checkIn.toIso8601String(),
        'checkOut': vehicle.checkOut?.toIso8601String(),
        'totalCost': vehicle.totalCost,
        'discount': vehicle.discount,
      };
      
      await _parkingLogBox.add(log);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<VehicleModel?> getVehicle(String plateNumber) async {
    return _vehicleBox.get(plateNumber);
  }

  Future<bool> updateVehicle(VehicleModel vehicle) async {
    try {
      await _vehicleBox.put(vehicle.plateNumber, vehicle);
      
      // Update parking log
      final logs = _parkingLogBox.values.where((log) => 
        log['plateNumber'] == vehicle.plateNumber && 
        log['checkOut'] == null
      ).toList();
      
      if (logs.isNotEmpty) {
        final log = logs.first;
        log['checkOut'] = vehicle.checkOut?.toIso8601String();
        log['totalCost'] = vehicle.totalCost;
        log['discount'] = vehicle.discount;
        
        final key = _parkingLogBox.keys.firstWhere(
          (k) => _parkingLogBox.get(k) == log,
          orElse: () => -1,
        );
        
        if (key != -1) {
          await _parkingLogBox.put(key, log);
        }
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<VehicleModel>> getAllVehicles() async {
    return _vehicleBox.values.toList();
  }

  Future<List<Map<String, dynamic>>> getParkingLogs() async {
    return _parkingLogBox.values.toList();
  }

  Future<void> clearAllData() async {
    await _vehicleBox.clear();
    await _parkingLogBox.clear();
  }
} 