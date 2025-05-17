import 'package:hive/hive.dart';
import 'package:quantum_parking_flutter/core/contants/hive_constants.dart';
import '../models/business_setup_model.dart';

abstract class SetupLocalDatasource {
  Future<BusinessSetupModel> saveSetup(BusinessSetupModel setup);
  Future<BusinessSetupModel?> getSetup();
  Future<void> saveBusinesses(List<BusinessSetupModel> businesses);
  Future<List<BusinessSetupModel>> getBusinesses();
  Future<void> clear();
}

class SetupLocalDatasourceImpl implements SetupLocalDatasource {
  static const String setupBoxName = HiveConstants.setupBox;
  static const String businessesBoxName = HiveConstants.businessesBox;
  static const String setupKey = HiveConstants.setupKey;
  static const String businessesKey = HiveConstants.businessesKey;

  final Box<BusinessSetupModel> setupBox;
  final Box<List<BusinessSetupModel>> businessesBox;

  SetupLocalDatasourceImpl({required this.setupBox, required this.businessesBox});

  @override
  Future<BusinessSetupModel> saveSetup(BusinessSetupModel setup) async {
    await setupBox.put(setupKey, setup);
    return setup;
  }

  @override
  Future<BusinessSetupModel?> getSetup() async {
    return setupBox.get(setupKey);
  }

  @override
  Future<void> saveBusinesses(List<BusinessSetupModel> businesses) async {
    await businessesBox.put(businessesKey, businesses);
  }

  @override
  Future<List<BusinessSetupModel>> getBusinesses() async {
    return businessesBox.get(businessesKey, defaultValue: []) ?? [];
  }

  @override
  Future<void> clear() async {
    await setupBox.clear();
    await businessesBox.clear();
  }
} 