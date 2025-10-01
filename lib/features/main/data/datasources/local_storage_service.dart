import 'package:hive/hive.dart';
import 'package:quantum_parking_flutter/features/records/data/models/vehicle_log_model.dart';
import 'package:quantum_parking_flutter/features/records/data/models/daily_closure_model.dart';
import '../models/vehicle_model.dart';

class LocalStorageService {
  static const String _vehicleBoxName = 'vehicles';
  static const String _parkingLogBoxName = 'parking_logs';
  static const String _dailyClosureBoxName = 'daily_closures';
  
  late Box<VehicleModel> _vehicleBox;
  late Box<VehicleLogModel> _parkingLogBox;
  late Box<DailyClosureModel> _dailyClosureBox;

  Future<void> init() async {
    _vehicleBox = await Hive.openBox<VehicleModel>(_vehicleBoxName);
    _parkingLogBox = await Hive.openBox<VehicleLogModel>(_parkingLogBoxName);
    _dailyClosureBox = await Hive.openBox<DailyClosureModel>(_dailyClosureBoxName);
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
      final log = VehicleLogModel(
        plateNumber: vehicle.plateNumber,
        vehicleType: vehicle.vehicleType,
        checkIn: vehicle.checkIn,
        checkOut: vehicle.checkOut,
        totalCost: vehicle.totalCost,
        discount: vehicle.discount,
        paymentMethod: vehicle.paymentMethod,
      );
      
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
      final logs = _parkingLogBox.values.toList();
      final index = logs.indexWhere((log) => 
        log.plateNumber == vehicle.plateNumber && log.checkOut == null
      );
      
      if (index != -1) {
        final log = logs[index];
        final updatedLog = VehicleLogModel(
          plateNumber: log.plateNumber,
          vehicleType: vehicle.vehicleType,
          checkIn: log.checkIn,
          checkOut: vehicle.checkOut,
          totalCost: vehicle.totalCost,
          discount: vehicle.discount,
          paymentMethod: vehicle.paymentMethod,
        );
        
        await _parkingLogBox.putAt(index, updatedLog);
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<VehicleModel>> getAllVehicles() async {
    return _vehicleBox.values.toList();
  }

  Future<List<VehicleLogModel>> getParkingLogs() async {
    return _parkingLogBox.values.toList();
  }

  Future<List<VehicleLogModel>> getVehicleParkingLogs(String plateNumber) async {
    return _parkingLogBox.values
        .where((log) => log.plateNumber == plateNumber)
        .toList();
  }

  Future<bool> saveDailyClosure(DailyClosureModel closure) async {
    try {
      final key = '${closure.date.year}-${closure.date.month}-${closure.date.day}';
      await _dailyClosureBox.put(key, closure);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<DailyClosureModel>> getDailyClosures(DateTime startDate, DateTime endDate) async {
    final closures = <DailyClosureModel>[];
    final currentDate = startDate;
    
    while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
      final key = '${currentDate.year}-${currentDate.month}-${currentDate.day}';
      final closure = _dailyClosureBox.get(key);
      if (closure != null) {
        closures.add(closure);
      }
      currentDate.add(const Duration(days: 1));
    }
    
    return closures;
  }

  Future<void> clearAllData() async {
    await _vehicleBox.clear();
    await _parkingLogBox.clear();
    await _dailyClosureBox.clear();
  }
} 