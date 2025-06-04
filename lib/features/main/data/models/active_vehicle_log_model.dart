class ActiveVehicleLogModel {
  final String id;
  final VehicleInfo vehicleId;
  final String businessId;
  final DateTime entryTime;
  final DateTime? exitTime;
  final int duration;
  final int cost;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  ActiveVehicleLogModel({
    required this.id,
    required this.vehicleId,
    required this.businessId,
    required this.entryTime,
    this.exitTime,
    required this.duration,
    required this.cost,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory ActiveVehicleLogModel.fromJson(Map<String, dynamic> json) {
    return ActiveVehicleLogModel(
      id: json['_id'] as String,
      vehicleId: VehicleInfo.fromJson(json['vehicleId'] as Map<String, dynamic>),
      businessId: json['businessId'] as String,
      entryTime: DateTime.parse(json['entryTime'] as String),
      exitTime: json['exitTime'] != null ? DateTime.parse(json['exitTime'] as String) : null,
      duration: json['duration'] as int,
      cost: json['cost'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      v: json['__v'] as int,
    );
  }
}

class VehicleInfo {
  final String id;
  final String plateNumber;
  final String vehicleType;

  VehicleInfo({
    required this.id,
    required this.plateNumber,
    required this.vehicleType,
  });

  factory VehicleInfo.fromJson(Map<String, dynamic> json) {
    return VehicleInfo(
      id: json['_id'] as String,
      plateNumber: json['plateNumber'] as String,
      vehicleType: json['vehicleType'] as String,
    );
  }
} 