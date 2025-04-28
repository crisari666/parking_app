import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/bloc/setup_bloc.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/bloc/setup_event.dart';
import 'package:auto_route/auto_route.dart';
import 'package:quantum_parking_flutter/features/setup/data/datasources/setup_local_datasource.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/bloc/setup_state.dart';
import 'package:quantum_parking_flutter/injection/injection.dart';
import 'package:quantum_parking_flutter/features/setup/presentation/widgets/setup_form.dart';
import 'package:quantum_parking_flutter/core/utils/custom_scroll_behaviour.dart';

@RoutePage()
class SetupPage extends StatelessWidget {
  const SetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SetupBloc(
        localDatasource: getIt.get<SetupLocalDatasource>(),
      )..add(SetupStarted()),
      child: BlocListener<SetupBloc, SetupState>(
        listener: (context, state) {
          if (state is SetupSuccess && state.setup != null) {
            if (state.isFromSave) {
              ScaffoldMessenger.of(context).showSnackBar(       
                  const SnackBar(
                    content: Text('Setup saved successfully!'),
                    backgroundColor: Colors.green,
                  ),
              );
            }
          } else if (state is SetupError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Setup'),
          ),
          body: ScrollConfiguration(
            behavior: NoGlowScrollBehaviour(),
            child: const SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SetupForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

