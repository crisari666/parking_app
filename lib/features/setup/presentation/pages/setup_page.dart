import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/bloc/setup_bloc.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/bloc/setup_event.dart';
import 'package:auto_route/auto_route.dart';
import 'package:quantum_parking_flutter/features/setup/data/datasources/setup_local_datasource.dart';
import 'package:quantum_parking_flutter/injection/injection.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/widgets/setup_form.dart';

@RoutePage()
class SetupPage extends StatelessWidget {
  const SetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SetupBloc(
        localDatasource: getIt.get<SetupLocalDatasource>(),
      )..add(SetupStarted()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Setup'),
        ),
        body: SetupForm(),
      ),
    );
  }
}

