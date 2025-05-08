import 'package:hive/hive.dart';

part 'business_setup_model.g.dart';

@HiveType(typeId: 1)
class BusinessSetupModel extends HiveObject {
  @HiveField(0)
  final String businessName;

  @HiveField(1)
  final String businessBrand;

  @HiveField(2)
  final double carHourCost;

  @HiveField(3)
  final double motorcycleHourCost;

  @HiveField(4)
  final double carMonthlyCost;

  @HiveField(5)
  final double motorcycleMonthlyCost;

  @HiveField(6)
  final double carDayCost;

  @HiveField(7)
  final double motorcycleDayCost;

  BusinessSetupModel({
    required this.businessName,
    required this.businessBrand,
    required this.carHourCost,
    required this.motorcycleHourCost,
    required this.carMonthlyCost,
    required this.motorcycleMonthlyCost,
    required this.carDayCost,
    required this.motorcycleDayCost,
  });
} 