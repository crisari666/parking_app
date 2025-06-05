import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quantum_parking_flutter/core/contants/hive_constants.dart';
import 'package:quantum_parking_flutter/core/theme/app_theme.dart';
import 'package:quantum_parking_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quantum_parking_flutter/features/main/presentation/bloc/main_bloc.dart';
import 'package:quantum_parking_flutter/injection/injection.dart';
import 'package:quantum_parking_flutter/routes/app_router.dart';
import 'features/setup/data/models/business_setup_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  
  // Initialize permissions
  await Permission.bluetooth.request();
  await Permission.bluetoothConnect.request();
  await Permission.bluetoothScan.request();
  await Permission.location.request();
  
  await registerMainDependencies();
  
  runApp(MyApp(setupBox: Hive.box<BusinessSetupModel>(HiveConstants.setupBox)));
}

class MyApp extends StatelessWidget {
  final Box<BusinessSetupModel>? setupBox;

  const MyApp({super.key, required this.setupBox});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();

    

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt.get<AuthBloc>()),
        BlocProvider(create: (_) => getIt.get<MainBloc>()),
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
