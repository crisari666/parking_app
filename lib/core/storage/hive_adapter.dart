import 'package:hive_flutter/hive_flutter.dart';
import 'package:quantum_parking_flutter/core/contants/hive_constants.dart';
import 'package:quantum_parking_flutter/features/auth/domain/models/login_response.dart';
import 'package:quantum_parking_flutter/features/auth/domain/models/user.dart';
import 'package:quantum_parking_flutter/features/config/data/models/app_config_model.dart';
import 'package:quantum_parking_flutter/features/config/data/models/stored_printer_model.dart';
import 'package:quantum_parking_flutter/features/main/data/models/vehicle_model.dart';
import 'package:quantum_parking_flutter/features/records/data/models/daily_closure_model.dart';
import 'package:quantum_parking_flutter/features/records/data/models/vehicle_log_model.dart';
import 'package:quantum_parking_flutter/features/setup/data/models/business_setup_model.dart';

class HiveAdapter {
  static Future<void> registerAdapters() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(VehicleModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(BusinessSetupModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(VehicleLogModelAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(DailyClosureModelAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(UserAdapter());
    }
    if (!Hive.isAdapterRegistered(10)) {
      Hive.registerAdapter(AppConfigModelAdapter());
    }
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(LoginResponseAdapter());
    }
    if (!Hive.isAdapterRegistered(11)) {
      Hive.registerAdapter(StoredPrinterModelAdapter());
    }
  }

  static Future<void> openBoxes() async {
    await Hive.openBox<VehicleModel>(HiveConstants.vehicleBox);
    await Hive.openBox<BusinessSetupModel>(HiveConstants.setupBox);
    await Hive.openBox<VehicleLogModel>(HiveConstants.vehicleLogBox);
    await Hive.openBox<DailyClosureModel>(HiveConstants.dailyClosureBox);
    await Hive.openBox<User>(HiveConstants.userBox);
    await Hive.openBox<AppConfigModel>(HiveConstants.configBox);
    await Hive.openBox<StoredPrinterModel>(HiveConstants.printerBox);
  }
} 