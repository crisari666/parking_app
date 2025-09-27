import 'package:equatable/equatable.dart';

class VehicleModel extends Equatable {
  final String? id;
  final String plateNumber;
  final String vehicleType;
  final String userName;
  final String phone;

  const VehicleModel({
    this.id,
    required this.plateNumber,
    required this.vehicleType,
    required this.userName,
    required this.phone,
  });

  VehicleModel copyWith({
    String? id,
    String? plateNumber,
    String? vehicleType,
    String? userName,
    String? phone,
  }) {
    return VehicleModel(
      id: id ?? this.id,
      plateNumber: plateNumber ?? this.plateNumber,
      vehicleType: vehicleType ?? this.vehicleType,
      userName: userName ?? this.userName,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'plateNumber': plateNumber,
      'vehicleType': vehicleType,
      'userName': userName,
      'phone': phone,
    };
  }

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['_id'] as String?,
      plateNumber: json['plateNumber'] as String,
      vehicleType: json['vehicleType'] as String,
      userName: json['userName'] as String,
      phone: json['phone'] as String,
    );
  }

  @override
  List<Object?> get props => [
        id,
        plateNumber,
        vehicleType,
        userName,
        phone,
      ];
}
