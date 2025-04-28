import 'package:hive/hive.dart';

part 'daily_closure_model.g.dart';

@HiveType(typeId: 4)
class DailyClosureModel {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final double totalIncome;

  @HiveField(2)
  final int totalVehicles;

  @HiveField(3)
  final Map<String, int> vehiclesByType;

  @HiveField(4)
  final Map<String, double> incomeByPaymentMethod;

  DailyClosureModel({
    required this.date,
    required this.totalIncome,
    required this.totalVehicles,
    required this.vehiclesByType,
    required this.incomeByPaymentMethod,
  });

  factory DailyClosureModel.fromJson(Map<String, dynamic> json) {
    return DailyClosureModel(
      date: DateTime.parse(json['date'] as String),
      totalIncome: json['totalIncome'] as double,
      totalVehicles: json['totalVehicles'] as int,
      vehiclesByType: Map<String, int>.from(json['vehiclesByType'] as Map),
      incomeByPaymentMethod: Map<String, double>.from(json['incomeByPaymentMethod'] as Map),
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'totalIncome': totalIncome,
    'totalVehicles': totalVehicles,
    'vehiclesByType': vehiclesByType,
    'incomeByPaymentMethod': incomeByPaymentMethod,
  };
} 