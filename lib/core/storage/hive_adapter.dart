import 'package:hive_flutter/hive_flutter.dart';
import 'package:quantum_parking_flutter/features/main/data/models/vehicle_model.dart';
import 'package:quantum_parking_flutter/features/setup/data/models/business_setup_model.dart';

class HiveAdapter {
  static Future<void> registerAdapters() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(VehicleModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(BusinessSetupModelAdapter());
    }
  }

  static Future<void> openBoxes() async {
    await Hive.openBox<VehicleModel>('vehicles');
    await Hive.openBox<BusinessSetupModel>('business_setup');
  }
} 