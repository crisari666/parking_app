// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AboutPage]
class AboutRoute extends PageRouteInfo<void> {
  const AboutRoute({List<PageRouteInfo>? children})
      : super(
          AboutRoute.name,
          initialChildren: children,
        );

  static const String name = 'AboutRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AboutPage();
    },
  );
}

/// generated route for
/// [ClosurePage]
class ClosureRoute extends PageRouteInfo<void> {
  const ClosureRoute({List<PageRouteInfo>? children})
      : super(
          ClosureRoute.name,
          initialChildren: children,
        );

  static const String name = 'ClosureRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ClosurePage();
    },
  );
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginPage();
    },
  );
}

/// generated route for
/// [LogoutPage]
class LogoutRoute extends PageRouteInfo<void> {
  const LogoutRoute({List<PageRouteInfo>? children})
      : super(
          LogoutRoute.name,
          initialChildren: children,
        );

  static const String name = 'LogoutRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LogoutPage();
    },
  );
}

/// generated route for
/// [MainPage]
class MainRoute extends PageRouteInfo<void> {
  const MainRoute({List<PageRouteInfo>? children})
      : super(
          MainRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MainPage();
    },
  );
}

/// generated route for
/// [PrinterSetupPage]
class PrinterSetupRoute extends PageRouteInfo<void> {
  const PrinterSetupRoute({List<PageRouteInfo>? children})
      : super(
          PrinterSetupRoute.name,
          initialChildren: children,
        );

  static const String name = 'PrinterSetupRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PrinterSetupPage();
    },
  );
}

/// generated route for
/// [RecordsPage]
class RecordsRoute extends PageRouteInfo<void> {
  const RecordsRoute({List<PageRouteInfo>? children})
      : super(
          RecordsRoute.name,
          initialChildren: children,
        );

  static const String name = 'RecordsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RecordsPage();
    },
  );
}

/// generated route for
/// [RegisterPage]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children})
      : super(
          RegisterRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RegisterPage();
    },
  );
}

/// generated route for
/// [SetupPage]
class SetupRoute extends PageRouteInfo<void> {
  const SetupRoute({List<PageRouteInfo>? children})
      : super(
          SetupRoute.name,
          initialChildren: children,
        );

  static const String name = 'SetupRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SetupPage();
    },
  );
}

/// generated route for
/// [UserListPage]
class UserListRoute extends PageRouteInfo<void> {
  const UserListRoute({List<PageRouteInfo>? children})
      : super(
          UserListRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const UserListPage();
    },
  );
}

/// generated route for
/// [UserMembershipPage]
class UserMembershipRoute extends PageRouteInfo<void> {
  const UserMembershipRoute({List<PageRouteInfo>? children})
      : super(
          UserMembershipRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserMembershipRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const UserMembershipPage();
    },
  );
}

/// generated route for
/// [VehicleLogsPage]
class VehicleLogsRoute extends PageRouteInfo<VehicleLogsRouteArgs> {
  VehicleLogsRoute({
    Key? key,
    required String plateNumber,
    required String vehicleType,
    List<PageRouteInfo>? children,
  }) : super(
          VehicleLogsRoute.name,
          args: VehicleLogsRouteArgs(
            key: key,
            plateNumber: plateNumber,
            vehicleType: vehicleType,
          ),
          initialChildren: children,
        );

  static const String name = 'VehicleLogsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VehicleLogsRouteArgs>();
      return VehicleLogsPage(
        key: args.key,
        plateNumber: args.plateNumber,
        vehicleType: args.vehicleType,
      );
    },
  );
}

class VehicleLogsRouteArgs {
  const VehicleLogsRouteArgs({
    this.key,
    required this.plateNumber,
    required this.vehicleType,
  });

  final Key? key;

  final String plateNumber;

  final String vehicleType;

  @override
  String toString() {
    return 'VehicleLogsRouteArgs{key: $key, plateNumber: $plateNumber, vehicleType: $vehicleType}';
  }
}

/// generated route for
/// [WrapperPage]
class WrapperRoute extends PageRouteInfo<void> {
  const WrapperRoute({List<PageRouteInfo>? children})
      : super(
          WrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'WrapperRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const WrapperPage();
    },
  );
}
