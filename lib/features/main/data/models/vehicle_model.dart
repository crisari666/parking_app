import 'package:hive/hive.dart';

part 'vehicle_model.g.dart';

@HiveType(typeId: 0)
class VehicleModel extends HiveObject {
  @HiveField(0)
  final String plateNumber;

  @HiveField(1)
  final String vehicleType;

  @HiveField(2)
  final DateTime checkIn;

  @HiveField(3)
  DateTime? checkOut;

  @HiveField(4)
  double? totalCost;

  @HiveField(5)
  double? discount;

  @HiveField(6)
  String? paymentMethod;

  VehicleModel({
    required this.plateNumber,
    required this.vehicleType,
    required this.checkIn,
    this.checkOut,
    this.totalCost,
    this.discount,
    this.paymentMethod,
  });
} 