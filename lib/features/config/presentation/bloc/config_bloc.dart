import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:quantum_parking_flutter/features/config/data/repositories/config_repository.dart';
import 'package:quantum_parking_flutter/features/config/presentation/bloc/config_event.dart';
import 'package:quantum_parking_flutter/features/config/presentation/bloc/config_state.dart';

class ConfigBloc extends Bloc<ConfigEvent, ConfigState> {
  final ConfigRepository _configRepository;

  ConfigBloc({
    required ConfigRepository configRepository,
  })  : _configRepository = configRepository,
        super(ConfigInitial()) {
    on<LoadAppConfig>(_onLoadAppConfig);
    on<CheckAppVersion>(_onCheckAppVersion);
    on<RefreshAppConfig>(_onRefreshAppConfig);
  }

  Future<void> _onLoadAppConfig(LoadAppConfig event, Emitter<ConfigState> emit) async {
    emit(ConfigLoading());
    try {
      final configs = await _configRepository.getAppConfig();
      emit(ConfigLoaded(configs));
    } catch (e) {
      emit(ConfigError(e.toString()));
    }
  }

  Future<void> _onCheckAppVersion(CheckAppVersion event, Emitter<ConfigState> emit) async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.buildNumber;
      
      final minBuildNumber = await _configRepository.getConfigValue('min_build_number');
      
      if (minBuildNumber != null) {
        final currentBuildNumber = int.tryParse(currentVersion) ?? 0;
        final minRequiredBuildNumber = int.tryParse(minBuildNumber) ?? 0;
        
        if (currentBuildNumber < minRequiredBuildNumber) {
          // Determine store URL based on platform
          String storeUrl;
          if (packageInfo.packageName.contains('android')) {
            storeUrl = 'https://play.google.com/store/apps/details?id=${packageInfo.packageName}';
          } else {
            storeUrl = 'https://apps.apple.com/app/id${packageInfo.packageName}';
          }
          
          emit(UpdateRequired(
            currentVersion: currentVersion,
            minRequiredVersion: minBuildNumber,
            storeUrl: storeUrl,
          ));
          return;
        }
      }
      
      // If no update required, load config
      add(LoadAppConfig());
    } catch (e) {
      emit(ConfigError(e.toString()));
    }
  }

  Future<void> _onRefreshAppConfig(RefreshAppConfig event, Emitter<ConfigState> emit) async {
    emit(ConfigLoading());
    try {
      await _configRepository.refreshConfig();
      final configs = await _configRepository.getAppConfig();
      emit(ConfigLoaded(configs));
    } catch (e) {
      emit(ConfigError(e.toString()));
    }
  }
} 