import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quantum_parking_flutter/core/theme/app_theme.dart';
import 'package:quantum_parking_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quantum_parking_flutter/features/closure/presentation/bloc/closure_bloc.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_bloc.dart';
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
  
  // Register the adapter
  Hive.registerAdapter(BusinessSetupModelAdapter());
  
  // Open the box
  final setupBox = await Hive.openBox<BusinessSetupModel>('setup_box');
  //Register SetupLocalDatasourceImpl with injection
  await configureDependencies();
  getIt.registerSingleton<SetupLocalDatasource>(SetupLocalDatasourceImpl(setupBox));
  
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
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => SetupBloc(localDatasource: getIt.get<SetupLocalDatasource>())),
        BlocProvider(create: (_) => MainBloc()),
        BlocProvider(create: (_) => ClosureBloc()),
        BlocProvider(create: (_) => RecordsBloc()),
      ],
      child: MaterialApp.router(
        title: 'Quantum Parking',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: appRouter.config(),
      ),
    );
  }
}
