import 'package:hive/hive.dart';

part 'business_setup_model.g.dart';

@HiveType(typeId: 1)
class BusinessSetupModel extends HiveObject {
  @HiveField(0)
  final String? name;

  @HiveField(1)
  final String businessName;

  @HiveField(2)
  final String businessBrand;

  @HiveField(3)
  final double carHourCost;

  @HiveField(4)
  final double motorcycleHourCost;

  @HiveField(5)
  final double carMonthlyCost;

  @HiveField(6)
  final double motorcycleMonthlyCost;

  @HiveField(7)
  final double carDayCost;

  @HiveField(8)
  final double motorcycleDayCost;

  @HiveField(9)
  final double carNightCost;

  @HiveField(10)
  final double motorcycleNightCost;

  @HiveField(11)
  final double studentMotorcycleHourCost;

  @HiveField(12)
  final String? businessId;

  BusinessSetupModel({
    this.name,
    required this.businessName,
    required this.businessBrand,
    required this.carHourCost,
    required this.motorcycleHourCost,
    required this.carMonthlyCost,
    required this.motorcycleMonthlyCost,
    required this.carDayCost,
    required this.motorcycleDayCost,
    required this.carNightCost,
    required this.motorcycleNightCost,
    required this.studentMotorcycleHourCost,
    this.businessId,
  });

  factory BusinessSetupModel.empty() {
    return BusinessSetupModel(
      businessName: '',
      businessBrand: '',
      carHourCost: 0,
      motorcycleHourCost: 0,
      carMonthlyCost: 0,
      motorcycleMonthlyCost: 0,
      carDayCost: 0,
      motorcycleDayCost: 0,
      carNightCost: 0,
      motorcycleNightCost: 0,
      studentMotorcycleHourCost: 0,
    );

  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'businessName': businessName,
      'businessBrand': businessBrand,
      'carHourCost': carHourCost,
      'motorcycleHourCost': motorcycleHourCost,
      'carMonthlyCost': carMonthlyCost,
      'motorcycleMonthlyCost': motorcycleMonthlyCost,
      'carDayCost': carDayCost,
      'motorcycleDayCost': motorcycleDayCost,
      'carNightCost': carNightCost,
      'motorcycleNightCost': motorcycleNightCost,
      'studentMotorcycleHourCost': studentMotorcycleHourCost,
      'businessId': businessId ?? '',
    };
  }

  factory BusinessSetupModel.fromJson(Map<String, dynamic> json) {
    return BusinessSetupModel(
      name: json['name'],
      businessName: json['businessName'],
      businessBrand: json['businessBrand'],
      carHourCost: (json['carHourCost'] as num).toDouble(),
      motorcycleHourCost: (json['motorcycleHourCost'] as num).toDouble(),
      carMonthlyCost: (json['carMonthlyCost'] as num).toDouble(),
      motorcycleMonthlyCost: (json['motorcycleMonthlyCost'] as num).toDouble(),
      carDayCost: (json['carDayCost'] as num).toDouble(),
      motorcycleDayCost: (json['motorcycleDayCost'] as num).toDouble(),
      carNightCost: (json['carNightCost'] as num).toDouble(),
      motorcycleNightCost: (json['motorcycleNightCost'] as num).toDouble(),
      studentMotorcycleHourCost: (json['studentMotorcycleHourCost'] as num).toDouble(),
      businessId: json['_id'],
    );
  }
} 