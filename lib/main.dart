import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quantum_parking_flutter/core/network/api_client.dart';
import 'package:quantum_parking_flutter/core/theme/app_theme.dart';
import 'package:quantum_parking_flutter/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:quantum_parking_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quantum_parking_flutter/features/auth/data/repositories/auth_repository.dart';
import 'package:quantum_parking_flutter/features/auth/domain/models/user.dart';
import 'package:quantum_parking_flutter/features/closure/presentation/bloc/closure_bloc.dart';
import 'package:quantum_parking_flutter/features/main/data/datasources/local_storage_service.dart';
import 'package:quantum_parking_flutter/features/main/data/models/vehicle_model.dart';
import 'package:quantum_parking_flutter/features/main/data/repositories/vehicle_repository_impl.dart'; 
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_bloc.dart';
import 'package:quantum_parking_flutter/features/records/data/models/vehicle_log_model.dart';
import 'package:quantum_parking_flutter/features/records/data/models/daily_closure_model.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/records_bloc.dart';
import 'package:quantum_parking_flutter/features/setup/data/datasources/setup_local_datasource.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/bloc/setup_bloc.dart';
import 'package:quantum_parking_flutter/injection/injection.dart';
import 'package:quantum_parking_flutter/routes/app_router.dart';
import 'features/setup/data/models/business_setup_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Initialize permissions
  await Permission.bluetooth.request();
  await Permission.bluetoothConnect.request();
  await Permission.bluetoothScan.request();
  await Permission.location.request();
  
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
  
  // Create AuthRepository
  final authRepository = AuthRepositoryImpl(
    AuthRemoteDataSourceImpl(ApiClient()),
  );
  
  //Register dependencies
  await configureDependencies();
  getIt.registerSingleton<SetupLocalDatasource>(SetupLocalDatasourceImpl(setupBox));
  getIt.registerSingleton<LocalStorageService>(localStorageService);
  getIt.registerSingleton<AuthRepository>(authRepository);

  getIt.registerSingleton<MainBloc>(MainBloc(
    localStorageService: getIt(),
    setupLocalDatasource: getIt(),
  ));
  
  runApp(MyApp(setupBox: setupBox));
}

class MyApp extends StatelessWidget {
  final Box<BusinessSetupModel>? setupBox;

  const MyApp({super.key, required this.setupBox});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(authRepository: getIt.get<AuthRepository>())),
        BlocProvider(create: (_) => SetupBloc(localDatasource: getIt.get<SetupLocalDatasource>())),
        BlocProvider(create: (_) => getIt.get<MainBloc>()),
        BlocProvider(create: (_) => ClosureBloc(vehicleRepository: VehicleRepositoryImpl(getIt.get<LocalStorageService>()))),
        BlocProvider(create: (_) => RecordsBloc(VehicleRepositoryImpl(getIt.get<LocalStorageService>()))),
      ],
      child: MaterialApp.router(
        title: 'Quantum Parking',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: appRouter.config(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('es'), // Default locale
      ),
    );
  }
}
