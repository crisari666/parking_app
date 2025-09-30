import 'package:quantum_parking_flutter/core/utils/date_time_service.dart';
import 'package:quantum_parking_flutter/features/main/data/datasources/local_storage_service.dart';
import 'package:quantum_parking_flutter/features/main/data/datasources/vehicle_log_remote_datasource.dart';
import 'package:quantum_parking_flutter/features/main/data/models/active_vehicle_log_model.dart';
import 'package:quantum_parking_flutter/features/main/data/models/vehicle_log_response_model.dart';
import 'package:quantum_parking_flutter/features/records/data/models/vehicle_log_model.dart';
import 'package:quantum_parking_flutter/features/records/data/models/daily_closure_model.dart';
import '../../data/models/vehicle_model.dart';
// Removed: import '../../data/models/check_out_data.dart';

abstract class VehicleRepository {
  Future<VehicleLogResponseModel> checkInVehicle(VehicleModel vehicle);
  Future<bool> checkOutVehicle(String plateNumber, DateTime checkOut, double totalCost, {double? discount});
  Future<VehicleModel?> getVehicle(String plateNumber);
  Future<List<VehicleModel>> getAllVehicles();
  Future<List<VehicleLogModel>> getParkingLogs();
  Future<List<VehicleLogModel>> getVehicleParkingLogs(String plateNumber);
  Future<List<ActiveVehicleLogModel>> getActiveVehicles();
  Future<bool> isVehicleCheckedIn(String plateNumber);
  Future<List<VehicleLogResponseModel>> getVehicleLogs(String plateNumber);
  Future<VehicleLogResponseModel> checkoutVehicle(String plateNumber, int cost);
  // New method for consolidated checkout data
  Future<CheckOutData> checkoutVehicleWithData(String plateNumber, int cost, {double? discount, String? paymentMethod});
  // Daily closure methods
  Future<DailyClosureModel> getDailyClosure(DateTime date);
  Future<bool> saveDailyClosure(DailyClosureModel closure);
  Future<List<DailyClosureModel>> getDailyClosures(DateTime startDate, DateTime endDate);
  // New method for getting current parking duration and cost
  Future<VehicleLogResponseModel?> getCurrentParkingDurationAndCost(String plateNumber);
  // New method for getting vehicle logs by date
  Future<List<ActiveVehicleLogModel>> getVehicleLogsByDate(String date);
} 

class VehicleRepositoryImpl implements VehicleRepository {
  final VehicleLogRemoteDatasource _vehicleLogRemoteDatasource;
  final LocalStorageService _localStorageService;

  VehicleRepositoryImpl({required LocalStorageService localStorageService, required VehicleLogRemoteDatasource vehicleLogRemoteDatasource}) : _localStorageService = localStorageService, _vehicleLogRemoteDatasource = vehicleLogRemoteDatasource;

  @override
  Future<VehicleLogResponseModel> checkInVehicle(VehicleModel vehicle) async {
    final vehicleLog = await _vehicleLogRemoteDatasource.createVehicleLog(vehicle.plateNumber, vehicle.vehicleType);
    return vehicleLog;
  }

  @override
  Future<bool> checkOutVehicle(String plateNumber, DateTime checkOut, double totalCost, {double? discount}) async {
    final vehicle = await _localStorageService.getVehicle(plateNumber);
    if (vehicle == null || vehicle.checkOut != null) {
      return false;
    }

    final updatedVehicle = VehicleModel(
      plateNumber: vehicle.plateNumber,
      vehicleType: vehicle.vehicleType,
      checkIn: vehicle.checkIn,
      checkOut: checkOut,
      totalCost: totalCost,
      discount: discount,
    );

    return await _localStorageService.updateVehicle(updatedVehicle);
  }

  
  
  @override
  Future<VehicleModel?> getVehicle(String plateNumber) async {
    return await _localStorageService.getVehicle(plateNumber);
  }

  @override
  Future<List<VehicleModel>> getAllVehicles() async {
    return await _localStorageService.getAllVehicles();
  }

  @override
  Future<List<VehicleLogModel>> getParkingLogs() async {
    return await _localStorageService.getParkingLogs();
  }

  @override
  Future<List<VehicleLogModel>> getVehicleParkingLogs(String plateNumber) async {
    return await _localStorageService.getVehicleParkingLogs(plateNumber);
  }

  @override
  Future<bool> isVehicleCheckedIn(String plateNumber) async {
    final vehicle = await _localStorageService.getVehicle(plateNumber);
    return vehicle != null && vehicle.checkOut == null;
  }

  @override
  Future<DailyClosureModel> getDailyClosure(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final allLogs = await _localStorageService.getParkingLogs();
    final dailyLogs = allLogs.where((log) => 
      log.checkIn.isAfter(startOfDay) && 
      log.checkIn.isBefore(endOfDay) &&
      log.checkOut != null
    ).toList();

    double totalIncome = 0;
    Map<String, int> vehiclesByType = {};
    Map<String, double> incomeByPaymentMethod = {};

    for (var log in dailyLogs) {
      if (log.totalCost != null) {
        totalIncome += log.totalCost!;
      }

      // Count vehicles by type
      if (log.vehicleType != null) {
        vehiclesByType[log.vehicleType!] = (vehiclesByType[log.vehicleType!] ?? 0) + 1;
      }

      // Sum income by payment method
      if (log.paymentMethod != null && log.totalCost != null) {
        incomeByPaymentMethod[log.paymentMethod!] = 
            (incomeByPaymentMethod[log.paymentMethod!] ?? 0) + log.totalCost!;
      }
    }

    return DailyClosureModel(
      date: startOfDay,
      totalIncome: totalIncome,
      totalVehicles: dailyLogs.length,
      vehiclesByType: vehiclesByType,
      incomeByPaymentMethod: incomeByPaymentMethod,
      vehicleLogs: dailyLogs,
    );
  }

  @override
  Future<bool> saveDailyClosure(DailyClosureModel closure) async {
    return await _localStorageService.saveDailyClosure(closure);
  }

  @override
  Future<List<DailyClosureModel>> getDailyClosures(DateTime startDate, DateTime endDate) async {
    return await _localStorageService.getDailyClosures(startDate, endDate);
  }

  @override
  Future<List<ActiveVehicleLogModel>> getActiveVehicles() async {
    return await _vehicleLogRemoteDatasource.getActiveVehicles();
  }

  @override
  Future<List<VehicleLogResponseModel>> getVehicleLogs(String plateNumber) async {
    return await _vehicleLogRemoteDatasource.getVehicleLogs(plateNumber);
  }

  @override
  Future<VehicleLogResponseModel?> getCurrentParkingDurationAndCost(String plateNumber) async {
    final lastLog = await _vehicleLogRemoteDatasource.getLastVehicleLog(plateNumber);
    if (lastLog == null) {
      throw Exception('No active parking log found for vehicle');
    }    
    return lastLog;
  }

  @override
  Future<VehicleLogResponseModel> checkoutVehicle(String plateNumber, int cost) async {
    return await _vehicleLogRemoteDatasource.checkoutVehicle(plateNumber, cost);
  }

  @override
  Future<CheckOutData> checkoutVehicleWithData(String plateNumber, int cost, {double? discount, String? paymentMethod}) async {
    final response = await _vehicleLogRemoteDatasource.checkoutVehicle(plateNumber, cost);
    // For parking time string, you may want to use a utility, here we use duration in minutes
    final parkingTimeString = '${response.duration ~/ 60}h ${response.duration % 60}m';
    final checkOutTime = response.exitTime ?? DateTime.now();
    return CheckOutData.fromVehicleLogResponse(
      response,
      DateTimeService.fromUtc(checkOutTime),
      discount,
      paymentMethod,
      parkingTimeString,
    );
  }

  @override
  Future<List<ActiveVehicleLogModel>> getVehicleLogsByDate(String date) async {
    return await _vehicleLogRemoteDatasource.getVehicleLogsByDate(date);
  }
} 