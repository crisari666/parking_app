import '../../domain/repositories/vehicle_repository.dart';
import '../datasources/local_storage_service.dart';
import '../models/vehicle_model.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  final LocalStorageService _localStorageService;

  VehicleRepositoryImpl(this._localStorageService);

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
  Future<List<Map<String, dynamic>>> getParkingLogs() async {
    return await _localStorageService.getParkingLogs();
  }

  @override
  Future<bool> isVehicleCheckedIn(String plateNumber) async {
    final vehicle = await _localStorageService.getVehicle(plateNumber);
    return vehicle != null && vehicle.checkOut == null;
  }
} 