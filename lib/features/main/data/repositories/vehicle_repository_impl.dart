import 'package:quantum_parking_flutter/features/records/data/models/vehicle_log_model.dart';
import 'package:quantum_parking_flutter/features/records/data/models/daily_closure_model.dart';

import '../../domain/repositories/vehicle_repository.dart';
import '../datasources/local_storage_service.dart';
import '../models/vehicle_model.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  final LocalStorageService _localStorageService;

  VehicleRepositoryImpl({required LocalStorageService localStorageService}) : _localStorageService = localStorageService;

  @override
  Future<bool> checkInVehicle(VehicleModel vehicle) async {
    return await _localStorageService.saveVehicle(vehicle);
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
} 