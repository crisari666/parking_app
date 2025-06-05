import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:injectable/injectable.dart';
import 'package:quantum_parking_flutter/core/app_bloc_observer.dart';
import 'package:quantum_parking_flutter/core/network/api_client.dart';
import 'package:quantum_parking_flutter/core/storage/hive_adapter.dart';
import 'package:quantum_parking_flutter/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:quantum_parking_flutter/features/auth/data/repositories/auth_repository.dart';
import 'package:quantum_parking_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quantum_parking_flutter/features/main/data/datasources/local_storage_service.dart';
import 'package:quantum_parking_flutter/features/main/data/datasources/vehicle_log_remote_datasource.dart';
import 'package:quantum_parking_flutter/features/main/data/repositories/vehicle_repository_impl.dart';
import 'package:quantum_parking_flutter/features/main/domain/repositories/vehicle_repository.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_bloc.dart';
import 'package:quantum_parking_flutter/features/setup/data/datasources/business_remote_datasource.dart';
import 'package:quantum_parking_flutter/features/setup/data/datasources/setup_local_datasource.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default  
  preferRelativeImports: true, // default  
  asExtension: true, // default  
) 
Future<void> configureDependencies() async => getIt.init();

Future<void> registerMainDependencies() async {

  Bloc.observer = AppBlocObserver();

  await configureDependencies();

  //ApiClient
  final apiClient = ApiClient();
  getIt.registerSingleton<ApiClient>(apiClient);

  //Hive setup
  await Hive.initFlutter();
  await HiveAdapter.registerAdapters();

  final localStorageService = LocalStorageService();
  await localStorageService.init();

  getIt.registerSingleton<LocalStorageService>(localStorageService);

  final vehicleLogRemoteDatasource = VehicleLogRemoteDatasourceImpl(apiClient: getIt());
  getIt.registerSingleton<VehicleLogRemoteDatasource>(vehicleLogRemoteDatasource);

  //Repositories
  final authRepository = AuthRepositoryImpl(AuthRemoteDataSourceImpl(apiClient),);
  getIt.registerSingleton<AuthRepository>(authRepository);

  final vehicleRepository = VehicleRepositoryImpl(
    localStorageService: getIt(),
    vehicleLogRemoteDatasource: getIt(),
  );
  getIt.registerSingleton<VehicleRepository>(vehicleRepository);


  //Datasources
  final setupLocalDatasource = SetupLocalDatasourceImpl();
  await setupLocalDatasource.init();
  getIt.registerSingleton<SetupLocalDatasource>(setupLocalDatasource);

  getIt.registerSingleton<BusinessRemoteDatasource>(BusinessRemoteDatasourceImpl(
    apiClient: getIt(),
  ));

  
  //Blocs
  getIt.registerSingleton<AuthBloc>(AuthBloc(
    authRepository: getIt(),
    setupLocalDatasource: getIt(),
  ));
  getIt.registerSingleton<MainBloc>(MainBloc(
    localStorageService: getIt(),
    setupLocalDatasource: getIt(),
    businessRemoteDatasource: getIt(),
  ));
}

