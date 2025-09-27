import 'package:equatable/equatable.dart';

class UserMembershipModel extends Equatable {
  final String? id;
  final String dateStart;
  final String dateEnd;
  final int value;
  final String businessId;
  final bool enable;
  final String plateNumber;
  final String userName;
  final String phone;
  final String vehicleType;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserMembershipModel({
    this.id,
    required this.dateStart,
    required this.dateEnd,
    required this.value,
    required this.businessId,
    required this.enable,
    required this.plateNumber,
    required this.userName,
    required this.phone,
    required this.vehicleType,
    this.createdAt,
    this.updatedAt,
  });

  UserMembershipModel copyWith({
    String? id,
    String? dateStart,
    String? dateEnd,
    int? value,
    String? businessId,
    bool? enable,
    String? plateNumber,
    String? userName,
    String? phone,
    String? vehicleType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserMembershipModel(
      id: id ?? this.id,
      dateStart: dateStart ?? this.dateStart,
      dateEnd: dateEnd ?? this.dateEnd,
      value: value ?? this.value,
      businessId: businessId ?? this.businessId,
      enable: enable ?? this.enable,
      plateNumber: plateNumber ?? this.plateNumber,
      userName: userName ?? this.userName,
      phone: phone ?? this.phone,
      vehicleType: vehicleType ?? this.vehicleType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateStart': dateStart,
      'dateEnd': dateEnd,
      'value': value,
      'businessId': businessId,
      'enable': enable,
      'plateNumber': plateNumber,
      'userName': userName,
      'phone': phone,
      'vehicleType': vehicleType,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory UserMembershipModel.fromJson(Map<String, dynamic> json) {
    return UserMembershipModel(
      id: json['_id'] as String?,
      dateStart: json['dateStart'] as String,
      dateEnd: json['dateEnd'] as String,
      value: json['value'] as int,
      businessId: json['businessId'] as String,
      enable: json['enable'] as bool,
      plateNumber: json['plateNumber'] as String,
      userName: json['userName'] as String,
      phone: json['phone'] as String,
      vehicleType: json['vehicleType'] as String,
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
        plateNumber,
        userName,
        phone,
        vehicleType,
        createdAt,
        updatedAt,
      ];
} 