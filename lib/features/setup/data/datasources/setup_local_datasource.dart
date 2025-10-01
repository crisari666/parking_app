import 'package:hive/hive.dart';
import 'package:quantum_parking_flutter/core/contants/hive_constants.dart';
import '../models/business_setup_model.dart';

abstract class SetupLocalDatasource {
  Future<BusinessSetupModel> saveSetup(BusinessSetupModel setup);
  Future<BusinessSetupModel?> getSetup();
  Future<void> saveBusinesses(BusinessSetupModel businesses);
  Future<BusinessSetupModel?> getBusiness();
  Future<void> clear();
}

class SetupLocalDatasourceImpl implements SetupLocalDatasource {
  static const String setupBoxName = HiveConstants.setupBox;
  static const String businessesBoxName = HiveConstants.businessesBox;
  static const String setupKey = HiveConstants.setupKey;
  static const String businessesKey = HiveConstants.businessesKey;

  late final Box<BusinessSetupModel> _setupBox;
  late final Box<BusinessSetupModel> _businessesBox;

  Future<void> init() async {
    _setupBox = await Hive.openBox<BusinessSetupModel>(setupBoxName);
    _businessesBox = await Hive.openBox<BusinessSetupModel>(businessesBoxName);
  }

  @override
  Future<BusinessSetupModel> saveSetup(BusinessSetupModel setup) async {
    await _setupBox.put(setupKey, setup);
    return setup;
  }

  @override
  Future<BusinessSetupModel?> getSetup() async {
    return _setupBox.get(setupKey);
  }

  @override
  Future<void> saveBusinesses(BusinessSetupModel businesses) async {
    await _businessesBox.put(businessesKey, businesses);
  }

  @override
  Future<BusinessSetupModel?> getBusiness() async {
    return _businessesBox.get(businessesKey);
  }

  @override
  Future<void> clear() async {
    await _setupBox.clear();
    await _businessesBox.clear();
  }
} 