import 'package:hive/hive.dart';
import '../models/business_setup_model.dart';

abstract class SetupLocalDatasource {
  Future<BusinessSetupModel> saveSetup(BusinessSetupModel setup);
  Future<BusinessSetupModel?> getSetup();
}

class SetupLocalDatasourceImpl implements SetupLocalDatasource {
  static const String boxName = 'setup_box';
  static const String setupKey = 'business_setup';

  final Box<BusinessSetupModel> box;

  SetupLocalDatasourceImpl(this.box);

  @override
  Future<BusinessSetupModel> saveSetup(BusinessSetupModel setup) async {
    await box.put(setupKey, setup);
    
    return setup;
  }

  @override
  Future<BusinessSetupModel?> getSetup() async {
    return box.get(setupKey);
  }
} 