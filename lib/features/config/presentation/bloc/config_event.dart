import 'package:equatable/equatable.dart';

abstract class ConfigEvent extends Equatable {
  const ConfigEvent();

  @override
  List<Object> get props => [];
}

class LoadAppConfig extends ConfigEvent {}

class CheckAppVersion extends ConfigEvent {}

class RefreshAppConfig extends ConfigEvent {} 