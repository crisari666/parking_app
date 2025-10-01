import 'package:equatable/equatable.dart';

class VehicleModel extends Equatable {
  final String? id;
  final String plateNumber;
  final String vehicleType;
  final String userName;
  final String phone;
  final bool? inParking;
  final String? businessId;
  final String? lastLog;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  const VehicleModel({
    this.id,
    required this.plateNumber,
    required this.vehicleType,
    required this.userName,
    required this.phone,
    this.inParking,
    this.businessId,
    this.lastLog,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  VehicleModel copyWith({
    String? id,
    String? plateNumber,
    String? vehicleType,
    String? userName,
    String? phone,
    bool? inParking,
    String? businessId,
    String? lastLog,
    String? createdAt,
    String? updatedAt,
    int? v,
  }) {
    return VehicleModel(
      id: id ?? this.id,
      plateNumber: plateNumber ?? this.plateNumber,
      vehicleType: vehicleType ?? this.vehicleType,
      userName: userName ?? this.userName,
      phone: phone ?? this.phone,
      inParking: inParking ?? this.inParking,
      businessId: businessId ?? this.businessId,
      lastLog: lastLog ?? this.lastLog,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'plateNumber': plateNumber,
      'vehicleType': vehicleType,
      'userName': userName,
      'phone': phone,
      'inParking': inParking,
      'businessId': businessId,
      'lastLog': lastLog,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['_id'] as String?,
      plateNumber: json['plateNumber'] as String,
      vehicleType: json['vehicleType'] as String,
      userName: json['userName'] as String,
      phone: json['phone'] as String,
      inParking: json['inParking'] as bool?,
      businessId: json['businessId'] as String?,
      lastLog: json['lastLog'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        plateNumber,
        vehicleType,
        userName,
        phone,
        inParking,
        businessId,
        lastLog,
        createdAt,
        updatedAt,
        v,
      ];
}
