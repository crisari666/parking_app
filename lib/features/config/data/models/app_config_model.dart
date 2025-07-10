import 'package:hive/hive.dart';
import 'package:quantum_parking_flutter/core/utils/date_time_service.dart';

part 'app_config_model.g.dart';

@HiveType(typeId: 10)
class AppConfigModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String key;

  @HiveField(2)
  final String value;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final DateTime updatedAt;

  AppConfigModel({
    required this.id,
    required this.key,
    required this.value,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppConfigModel.fromJson(Map<String, dynamic> json) {
    return AppConfigModel(
      id: json['_id'] ?? '',
      key: json['key'] ?? '',
      value: json['value'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTimeService.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTimeService.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'key': key,
      'value': value,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'AppConfigModel(id: $id, key: $key, value: $value)';
  }
} 