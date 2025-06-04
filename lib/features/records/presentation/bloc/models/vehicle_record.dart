import 'package:equatable/equatable.dart';

class VehicleRecord extends Equatable {
  final String plateNumber;
  final String vehicleType;
  final DateTime checkIn;
  final DateTime? checkOut;
  final double? totalCost;
  final String? paymentMethod;

  const VehicleRecord({
    required this.plateNumber,
    required this.vehicleType,
    required this.checkIn,
    this.checkOut,
    this.totalCost,
    this.paymentMethod,
  });

  String get duration {
    if (checkOut == null) return 'Still parked';
    
    final difference = checkOut!.difference(checkIn);
    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);
    
    if (hours > 0) {
      return '$hours hour${hours > 1 ? 's' : ''} $minutes minute${minutes > 1 ? 's' : ''}';
    } else {
      return '$minutes minute${minutes > 1 ? 's' : ''}';
    }
  }

  @override
  List<Object?> get props => [
    plateNumber,
    vehicleType,
    checkIn,
    checkOut,
    totalCost,
    paymentMethod,
  ];
}