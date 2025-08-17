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
import 'package:quantum_parking_flutter/features/config/data/datasources/config_local_datasource.dart';
import 'package:quantum_parking_flutter/features/config/data/datasources/config_remote_datasource.dart';
import 'package:quantum_parking_flutter/features/config/data/repositories/config_repository.dart';
import 'package:quantum_parking_flutter/features/config/domain/services/config_service.dart';
import 'package:quantum_parking_flutter/features/config/presentation/bloc/config_bloc.dart';
import 'package:quantum_parking_flutter/features/main/data/datasources/local_storage_service.dart';
import 'package:quantum_parking_flutter/features/main/data/datasources/vehicle_log_remote_datasource.dart';
import 'package:quantum_parking_flutter/features/main/data/repositories/printer_repository.dart';
import 'package:quantum_parking_flutter/features/main/domain/repositories/vehicle_repository.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_bloc.dart';
import 'package:quantum_parking_flutter/core/services/ticket_printer_service.dart';
import 'package:quantum_parking_flutter/features/setup/data/datasources/business_remote_datasource.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/records_bloc.dart';
import 'package:quantum_parking_flutter/features/setup/data/datasources/setup_local_datasource.dart';
import 'package:quantum_parking_flutter/features/user/data/datasources/user_remote_datasource.dart';
import 'package:quantum_parking_flutter/features/user/data/repositories/user_repository_impl.dart';
import 'package:quantum_parking_flutter/features/user/domain/repositories/user_repository.dart';
import 'package:quantum_parking_flutter/features/user/domain/services/user_service.dart';
import 'package:quantum_parking_flutter/features/user/presentation/bloc/user_bloc.dart';
import 'package:quantum_parking_flutter/features/user_membership/data/datasources/user_membership_remote_datasource.dart';
import 'package:quantum_parking_flutter/features/user_membership/data/repositories/user_membership_repository_impl.dart';
import 'package:quantum_parking_flutter/features/user_membership/domain/repositories/user_membership_repository.dart';
import 'package:quantum_parking_flutter/features/user_membership/presentation/bloc/user_membership_bloc.dart';
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

  // Printer Repository
  final printerRepository = PrinterRepository();
  getIt.registerSingleton<PrinterRepository>(printerRepository);

  // Ticket Printer Service
  final ticketPrinterService = TicketPrinterService();
  getIt.registerSingleton<TicketPrinterService>(ticketPrinterService);

  getIt.registerSingleton<ConfigRemoteDatasource>(ConfigRemoteDatasourceImpl(
    apiClient: getIt(),
  ));

  final configLocalDatasource = ConfigLocalDatasourceImpl();
  await configLocalDatasource.init();
  getIt.registerSingleton<ConfigLocalDatasource>(configLocalDatasource);

  final configRepository = ConfigRepositoryImpl(
    remoteDatasource: getIt(),
    localDatasource: getIt(),
  );
  getIt.registerSingleton<ConfigRepository>(configRepository);

  final configService = ConfigService(getIt());
  getIt.registerSingleton<ConfigService>(configService);


  //Datasources
  final setupLocalDatasource = SetupLocalDatasourceImpl();
  await setupLocalDatasource.init();
  getIt.registerSingleton<SetupLocalDatasource>(setupLocalDatasource);

  

  getIt.registerSingleton<BusinessRemoteDatasource>(BusinessRemoteDatasourceImpl(
    apiClient: getIt(),
  ));

  // User dependencies
  getIt.registerSingleton<UserRemoteDataSource>(UserRemoteDataSourceImpl(
    getIt(),
  ));

  getIt.registerSingleton<UserRepository>(UserRepositoryImpl(
    getIt(),
  ));

  getIt.registerSingleton<UserService>(UserService(
    getIt(),
  ));

  
  //Blocs
  getIt.registerSingleton<AuthBloc>(AuthBloc(
    authRepository: getIt(),
    setupLocalDatasource: getIt(),
  ));
  getIt.registerSingleton<MainBloc>(MainBloc(
    vehicleRepository: getIt(),
    localStorageService: getIt(),
    setupLocalDatasource: getIt(),
    businessRemoteDatasource: getIt(),
    printerRepository: getIt(),
    ticketPrinterService: getIt(),
  ));
  getIt.registerSingleton<ConfigBloc>(ConfigBloc(
    configRepository: getIt(),
  ));

  // Records Bloc
  getIt.registerSingleton<RecordsBloc>(RecordsBloc(
    vehicleRepository: getIt(),
    ticketPrinterService: getIt(),
    setupLocalDatasource: getIt(),
  ));

  // User Bloc
  getIt.registerSingleton<UserBloc>(UserBloc(
    userRepository: getIt(),
    userService: getIt(),
  ));

  // User Membership dependencies
  getIt.registerSingleton<UserMembershipRemoteDataSource>(UserMembershipRemoteDataSourceImpl(
    getIt(),
  ));

  getIt.registerSingleton<UserMembershipRepository>(UserMembershipRepositoryImpl(
    getIt(),
  ));

  // User Membership Bloc
  getIt.registerSingleton<UserMembershipBloc>(UserMembershipBloc(
    userMembershipRepository: getIt(),
  ));
}

