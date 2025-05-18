import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:quantum_parking_flutter/features/auth/presentation/pages/login_page.dart';
import 'package:quantum_parking_flutter/features/auth/presentation/pages/logout_page.dart';
import 'package:quantum_parking_flutter/features/auth/presentation/pages/register_page.dart';
import 'package:quantum_parking_flutter/features/closure/presentation/pages/closure_page.dart';
import 'package:quantum_parking_flutter/features/main/presentation/pages/main_page.dart';
import 'package:quantum_parking_flutter/features/main/presentation/pages/printer_setup_page.dart';
import 'package:quantum_parking_flutter/features/records/presentation/bloc/models/vehicle_record.dart';
import 'package:quantum_parking_flutter/features/records/presentation/pages/records_page.dart';
import 'package:quantum_parking_flutter/features/records/presentation/pages/vehicle_logs_page.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/pages/setup_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route',)
class AppRouter extends RootStackRouter {
  
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: LoginRoute.page, path: '/login', initial: true),
    AutoRoute(page: RegisterRoute.page, path: '/register'),

    AutoRoute(page: MainRoute.page, path: '/main', children: [
      AutoRoute(page: SetupRoute.page, path: 'setup'),
      AutoRoute(page: ClosureRoute.page, path: 'closure'),
      AutoRoute(page: RecordsRoute.page, path: 'records'),
      AutoRoute(page: VehicleLogsRoute.page, path: 'vehicle-logs'),
      AutoRoute(page: PrinterSetupRoute.page, path: 'printer-setup'),
    ]),
    AutoRoute(page: LogoutRoute.page, path: '/logout'),
  ];

  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRouteGuard> get guards => [];


}


