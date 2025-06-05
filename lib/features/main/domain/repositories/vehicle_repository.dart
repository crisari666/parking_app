import 'package:quantum_parking_flutter/features/main/data/models/active_vehicle_log_model.dart';
import 'package:quantum_parking_flutter/features/main/data/models/vehicle_log_response_model.dart';
import 'package:quantum_parking_flutter/features/records/data/models/vehicle_log_model.dart';
import 'package:quantum_parking_flutter/features/records/data/models/daily_closure_model.dart';

import '../../data/models/vehicle_model.dart';

abstract class VehicleRepository {
  Future<bool> checkInVehicle(VehicleModel vehicle);
  Future<bool> checkOutVehicle(String plateNumber, DateTime checkOut, double totalCost, {double? discount});
  Future<VehicleModel?> getVehicle(String plateNumber);
  Future<List<VehicleModel>> getAllVehicles();
  Future<List<VehicleLogModel>> getParkingLogs();
  Future<List<VehicleLogModel>> getVehicleParkingLogs(String plateNumber);
  Future<List<ActiveVehicleLogModel>> getActiveVehicles();
  Future<bool> isVehicleCheckedIn(String plateNumber);
  Future<List<VehicleLogResponseModel>> getVehicleLogs(String plateNumber);
  // Daily closure methods
  Future<DailyClosureModel> getDailyClosure(DateTime date);
  Future<bool> saveDailyClosure(DailyClosureModel closure);
  Future<List<DailyClosureModel>> getDailyClosures(DateTime startDate, DateTime endDate);

} 