
import 'package:equatable/equatable.dart';

class VehicleRecord extends Equatable {
  final String plateNumber;
  final String vehicleType;
  final DateTime checkIn;
  final DateTime? checkOut;
  final double? totalCost;

  const VehicleRecord({
    required this.plateNumber,
    required this.vehicleType,
    required this.checkIn,
    this.checkOut,
    this.totalCost,
  });

  @override
  List<Object?> get props => [
        plateNumber,
        vehicleType,
        checkIn,
        checkOut,
        totalCost,
      ];
}