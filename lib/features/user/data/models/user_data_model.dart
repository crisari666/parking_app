import 'package:quantum_parking_flutter/features/user/domain/models/user_model.dart';

class UserDataModel extends UserModel {
  const UserDataModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    super.isActive = true,
    required super.createdAt,
    super.updatedAt,
  });

  factory UserDataModel.fromDomain(UserModel user) {
    return UserDataModel(
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role,
      isActive: user.isActive,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }

  UserModel toDomain() {
    return UserModel(
      id: id,
      name: name,
      email: email,
      role: role,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }
} 