import 'package:equatable/equatable.dart';
import 'package:quantum_parking_flutter/features/user_membership/domain/models/vehicle_model.dart';

class MembershipModel extends Equatable {
  final String? id;
  final DateTime? dateStart;
  final DateTime? dateEnd;
  final int value;
  final String businessId;
  final bool enable;
  final VehicleModel vehicleId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MembershipModel({
    this.id,
    this.dateStart,
    this.dateEnd,
    required this.value,
    required this.businessId,
    required this.enable,
    required this.vehicleId,
    this.createdAt,
    this.updatedAt,
  });

  MembershipModel copyWith({
    String? id,
    DateTime? dateStart,
    DateTime? dateEnd,
    int? value,
    String? businessId,
    bool? enable,
    VehicleModel? vehicleId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MembershipModel(
      id: id ?? this.id,
      dateStart: dateStart ?? this.dateStart,
      dateEnd: dateEnd ?? this.dateEnd,
      value: value ?? this.value,
      businessId: businessId ?? this.businessId,
      enable: enable ?? this.enable,
      vehicleId: vehicleId ?? this.vehicleId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'dateStart': dateStart?.toIso8601String(),
      'dateEnd': dateEnd?.toIso8601String(),
      'value': value,
      'businessId': businessId,
      'enable': enable,
      'vehicleId': vehicleId.toJson(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory MembershipModel.fromJson(Map<String, dynamic> json) {
    return MembershipModel(
      id: json['_id'] as String?,
      dateStart: json['dateStart'] != null 
          ? DateTime.parse(json['dateStart'] as String)
          : null,
      dateEnd: json['dateEnd'] != null 
          ? DateTime.parse(json['dateEnd'] as String)
          : null,
      value: json['value'] as int,
      businessId: json['businessId'] as String,
      enable: json['enable'] as bool,
      vehicleId: VehicleModel.fromJson(json['vehicleId'] as Map<String, dynamic>),
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        dateStart,
        dateEnd,
        value,
        businessId,
        enable,
        vehicleId,
        createdAt,
        updatedAt,
      ];
}
