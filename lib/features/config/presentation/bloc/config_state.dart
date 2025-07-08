import 'package:equatable/equatable.dart';
import 'package:quantum_parking_flutter/features/config/data/models/app_config_model.dart';

abstract class ConfigState extends Equatable {
  const ConfigState();

  @override
  List<Object> get props => [];
}

class ConfigInitial extends ConfigState {}

class ConfigLoading extends ConfigState {}

class ConfigLoaded extends ConfigState {
  final List<AppConfigModel> configs;

  const ConfigLoaded(this.configs);

  @override
  List<Object> get props => [configs];
}

class ConfigError extends ConfigState {
  final String message;

  const ConfigError(this.message);

  @override
  List<Object> get props => [message];
}

class UpdateRequired extends ConfigState {
  final String currentVersion;
  final String minRequiredVersion;
  final String storeUrl;

  const UpdateRequired({
    required this.currentVersion,
    required this.minRequiredVersion,
    required this.storeUrl,
  });

  @override
  List<Object> get props => [currentVersion, minRequiredVersion, storeUrl];
} 