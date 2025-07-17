import 'package:quantum_parking_flutter/features/user/domain/models/user_model.dart';

class UserDataModel extends UserModel {
  const UserDataModel({
    required super.id,
    required super.user,
    required super.name,
    required super.lastName,
    super.email,
    required super.role,
    required super.business,
    super.isActive = true,
    required super.createdAt,
    super.updatedAt,
  });

  factory UserDataModel.fromDomain(UserModel user) {
    return UserDataModel(
      id: user.id,
      user: user.user,
      name: user.name,
      lastName: user.lastName,
      email: user.email,
      role: user.role,
      business: user.business,
      isActive: user.isActive,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }

  UserModel toDomain() {
    return UserModel(
      id: id,
      user: user,
      name: name,
      lastName: lastName,
      email: email,
      role: role,
      business: business,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      id: json['_id'] as String,
      user: json['user'] as String,
      name: json['name'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      email: json['email'] as String?,
      role: json['role'] as String,
      business: json['business'] as String,
      isActive: json['enabled'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'name': name,
      'lastName': lastName,
      'email': email,
      'role': role,
      'business': business,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toCreateUserJson() {
    return {
      'email': email,
      'password': user, // Using user field as password for now
    };
  }

  static Map<String, dynamic> createUserRequest(String email, String password) {
    return {
      'email': email,
      'password': password,
    };
  }
} 