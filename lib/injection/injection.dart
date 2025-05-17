import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:injectable/injectable.dart';
import 'package:quantum_parking_flutter/core/network/api_client.dart';
import 'package:quantum_parking_flutter/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:quantum_parking_flutter/features/auth/data/repositories/auth_repository.dart';
import 'package:quantum_parking_flutter/features/auth/domain/models/user.dart';
import 'package:quantum_parking_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quantum_parking_flutter/features/main/data/datasources/local_storage_service.dart';
import 'package:quantum_parking_flutter/features/main/data/models/vehicle_model.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_bloc.dart';
import 'package:quantum_parking_flutter/features/records/data/models/daily_closure_model.dart';
import 'package:quantum_parking_flutter/features/records/data/models/vehicle_log_model.dart';
import 'package:quantum_parking_flutter/features/setup/data/datasources/business_remote_datasource.dart';
import 'package:quantum_parking_flutter/features/setup/data/datasources/setup_local_datasource.dart';
import 'package:quantum_parking_flutter/features/setup/data/models/business_setup_model.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default  
  preferRelativeImports: true, // default  
  asExtension: true, // default  
) 
Future<void> configureDependencies() async => getIt.init();

Future<void> registerMainDependencies() async {

  await configureDependencies();

  final apiClient = ApiClient();

  getIt.registerSingleton<ApiClient>(apiClient);

  final authRepository = AuthRepositoryImpl(
    AuthRemoteDataSourceImpl(apiClient),
  );



  getIt.registerSingleton<AuthRepository>(authRepository);

  getIt.registerSingleton<AuthBloc>(AuthBloc(authRepository: getIt()));

  await Hive.initFlutter();
  // Register the adapters
  Hive.registerAdapter(BusinessSetupModelAdapter());
  Hive.registerAdapter(VehicleModelAdapter());
  Hive.registerAdapter(VehicleLogModelAdapter());
  Hive.registerAdapter(DailyClosureModelAdapter());
  Hive.registerAdapter(UserAdapter());
  
  // Open the boxes
  final setupBox = await Hive.openBox<BusinessSetupModel>('setup_box');
  
  // Initialize LocalStorageService
  final localStorageService = LocalStorageService();
  await localStorageService.init();
  
  // Create AuthRepositor
  getIt.registerSingleton<SetupLocalDatasource>(SetupLocalDatasourceImpl(setupBox));
  getIt.registerSingleton<LocalStorageService>(localStorageService);
  getIt.registerSingleton<BusinessRemoteDatasource>(BusinessRemoteDatasourceImpl(
    apiClient: getIt(),
  ));

  getIt.registerSingleton<MainBloc>(MainBloc(
    localStorageService: getIt(),
    setupLocalDatasource: getIt(),
  ));
}
