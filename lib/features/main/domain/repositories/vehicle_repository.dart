import 'package:quantum_parking_flutter/features/records/data/models/vehicle_log_model.dart';

import '../../data/models/vehicle_model.dart';

abstract class VehicleRepository {
  Future<bool> checkInVehicle(VehicleModel vehicle);
  Future<bool> checkOutVehicle(String plateNumber, DateTime checkOut, double totalCost, {double? discount});
  Future<VehicleModel?> getVehicle(String plateNumber);
  Future<List<VehicleModel>> getAllVehicles();
  Future<List<VehicleLogModel>> getParkingLogs();
  Future<List<VehicleLogModel>> getVehicleParkingLogs(String plateNumber);
  Future<bool> isVehicleCheckedIn(String plateNumber);
} 