import 'package:hive/hive.dart';

part 'vehicle_log_model.g.dart';

@HiveType(typeId: 2)
class VehicleLogModel {
  @HiveField(0)
  final String plateNumber;

  @HiveField(1)
  final DateTime checkIn;

  @HiveField(2)
  final DateTime? checkOut;

  @HiveField(3)
  final double? totalCost;

  @HiveField(4)
  final double? discount;

  @HiveField(5)
  final String? vehicleType;

  @HiveField(6)
  final String? paymentMethod;


  VehicleLogModel({
    required this.plateNumber,
    required this.checkIn,
    required this.vehicleType,
    this.checkOut,
    this.totalCost,
    this.discount,
    this.paymentMethod,
  });

  factory VehicleLogModel.fromJson(Map<String, dynamic> json) {
    return VehicleLogModel(
      plateNumber: json['plateNumber'] as String,
      checkIn: DateTime.parse(json['checkIn'] as String),
      checkOut: json['checkOut'] != null ? DateTime.parse(json['checkOut'] as String) : null,
      totalCost: json['totalCost'] as double?,
      discount: json['discount'] as double?,
      vehicleType: json['vehicleType'] as String,
      paymentMethod: json['paymentMethod'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'plateNumber': plateNumber,
    'checkIn': checkIn.toIso8601String(),
    'checkOut': checkOut?.toIso8601String(),
    'totalCost': totalCost,
    'discount': discount,
  };
}