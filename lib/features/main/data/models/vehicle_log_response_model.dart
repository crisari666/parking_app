class VehicleLogResponseModel {
  final String vehicleId;
  final String businessId;
  final DateTime entryTime;
  final DateTime? exitTime;
  final int duration;
  final int cost;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  VehicleLogResponseModel({
    required this.vehicleId,
    required this.businessId,
    required this.entryTime,
    this.exitTime,
    required this.duration,
    required this.cost,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory VehicleLogResponseModel.fromJson(Map<String, dynamic> json) {
    return VehicleLogResponseModel(
      vehicleId: json['vehicleId'] as String,
      businessId: json['businessId'] as String,
      entryTime: DateTime.parse(json['entryTime'] as String),
      exitTime: json['exitTime'] != null ? DateTime.parse(json['exitTime'] as String) : null,
      duration: json['duration'] as int,
      cost: json['cost'] as int,
      id: json['_id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      v: json['__v'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'vehicleId': vehicleId,
    'businessId': businessId,
    'entryTime': entryTime.toIso8601String(),
    'exitTime': exitTime?.toIso8601String(),
    'duration': duration,
    'cost': cost,
    '_id': id,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    '__v': v,
  };
} 