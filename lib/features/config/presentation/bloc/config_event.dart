import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

abstract class ConfigEvent extends Equatable {
  const ConfigEvent();

  @override
  List<Object> get props => [];
}

class LoadAppConfig extends ConfigEvent {
  final VoidCallback afterRefresh;
  const LoadAppConfig({required this.afterRefresh});

  @override
  List<Object> get props => [afterRefresh];
}

class CheckAppVersion extends ConfigEvent {
  final VoidCallback? afterCheck;
  const CheckAppVersion({this.afterCheck});

  @override
  List<Object> get props => [afterCheck ?? 0];
}

class RefreshAppConfig extends ConfigEvent {} 